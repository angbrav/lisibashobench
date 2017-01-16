%% -------------------------------------------------------------------
%%
%% basho_bench: Benchmarking Suite
%%
%% Copyright (c) 2009-2010 Basho Techonologies
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------
-module(basho_bench_driver_clocks).

-export([new/1,
         run/4,
         get_parts/1]).

-include("basho_bench.hrl").

-define(TIMEOUT, 20000).
-record(state, {worker_id,
                time,
                num_updates,
                num_reads,
                clock,
                pb_port,
                target_node,
                start_in_straggler,
                nodes,
                num_partitions,
                skewed_part_rate,
                key_only_read,
                key_read_update,
                key_only_update}).

%% ====================================================================
%% API
%% ====================================================================

new(Id) ->
    %% Make sure bitcask is available
    case code:which(antidote) of
        non_existing ->
            ?FAIL_MSG("~s requires antidote to be available on code path.\n",
                      [?MODULE]);
        _ ->
            ok
    end,

    Nodes   = basho_bench_config:get(antidote_nodes),
    Cookie  = basho_bench_config:get(antidote_cookie),
    MyNode  = basho_bench_config:get(antidote_mynode, [basho_bench, longnames]),
    KeyOnlyRead  = basho_bench_config:get(key_only_read),
    KeyReadUpdate  = basho_bench_config:get(key_read_update),
    KeyOnlyUpdate  = basho_bench_config:get(key_only_update),

    NumPartitions  = basho_bench_config:get(num_partitions),
    SkewedPartRate = basho_bench_config:get(skewed_part_rate),
    StartInStraggler = basho_bench_config:get(start_in_straggler),

    %% Try to spin up net_kernel
    case net_kernel:start(MyNode) of
        {ok, _} ->
            ?INFO("Net kernel started as ~p\n", [node()]);
        {error, {already_started, _}} ->
            ok;
        {error, Reason} ->
            ?FAIL_MSG("Failed to start net_kernel for ~p: ~p\n", [?MODULE, Reason])
    end,

    %% Initialize cookie for each of the nodes
    true = erlang:set_cookie(node(), Cookie),
    [true = erlang:set_cookie(N, Cookie) || N <- Nodes],

    %% Choose the node using our ID as a modulus
    %TargetNode = lists:nth((Id rem length(Nodes)+1), Nodes),
    %?INFO("Using target node ~p for worker ~p\n", [TargetNode, Id]),

    {A1,A2,A3} = now(),
    random:seed(A1, A2, A3), 

    {ok, #state{nodes=Nodes, worker_id=Id, key_only_read=KeyOnlyRead, key_read_update=KeyReadUpdate, key_only_update=KeyOnlyUpdate,
        num_partitions=NumPartitions, skewed_part_rate=SkewedPartRate, start_in_straggler=StartInStraggler}}.

run(read_update_txn, KeyGen, _ValueGen, State=#state{nodes=Nodes, key_only_read=KOR, key_only_update=KOU, 
        num_partitions=NP, skewed_part_rate=LeastRate, key_read_update=KRU, start_in_straggler=StartInStraggler}) ->
    Node = lists:nth((KeyGen() rem length(Nodes)+1), Nodes),

    ReadUpdates = get_operation(KOR, KOU, KRU, LeastRate, NP, KeyGen, sets:new(), []),
    %Parts = get_parts(ReadUpdates),
    %lager:warning("Partitions are ~w", [ReadUpdates]),

    StartPartId = get_start_id(NP, StartInStraggler),
    Metadata = retry_until_commit(Node, StartPartId, ReadUpdates, 0),
    {ok, Metadata, State}.

retry_until_commit(Node, StartPartId, ReadUpdates, Retried) ->
    Response = rpc:call(Node, antidote, execute_tx, [StartPartId, ReadUpdates]),
    case Response of
        {ok, {_, _ReadSet, _CausalClock, TimeWaited, VersionsMissed}} ->
            {TimeWaited, VersionsMissed, Retried};
        %{ok, {_, _ReadSet, _CausalClock}} ->
            %case Retried of 0 -> ok; _ -> lager:warning("Retried ~w times already", [Retried]) end,
        %    {0, [0], Retried};
        {error, _} ->
            retry_until_commit(Node, StartPartId, ReadUpdates, Retried+1)
    end.

get_operation(0, 0, 0, _, _, _, _Set, List) ->
    lists:reverse(List);
get_operation(0, 0, N, LeastRate, NP, KeyGen, Set, List) ->
    case sets:size(Set) of
        0 ->
            Num = get_first_key(LeastRate, NP, KeyGen), 
            get_operation(0, 0, N-1, LeastRate, NP, KeyGen, sets:add_element(Num, Set), [{read, Num}, {update, Num, increment, 1}]);
        _ ->
            Num = get_key(LeastRate, NP, KeyGen), 
            %lager:warning("Key is ~w", [Num]),
            case sets:is_element(Num, Set) of
                true ->
                    get_operation(0, 0, N, LeastRate, NP, KeyGen, Set, List); 
                false ->
                    get_operation(0, 0, N-1, LeastRate, NP, KeyGen, sets:add_element(Num, Set), [{read, Num}, {update, Num, increment, 1}]++List)
            end
    end;
get_operation(0, M, N, LeastRate, NP, KeyGen, Set, List) ->
    case sets:size(Set) of
        0 ->
            Num = get_first_key(LeastRate, NP, KeyGen), 
            get_operation(0, M-1, N, LeastRate, NP, KeyGen, sets:add_element(Num, Set), [{update, Num, increment, 1}]);
        _ ->
            Num = get_key(LeastRate, NP, KeyGen), 
            %lager:warning("Key is ~w", [Num]),
            case sets:is_element(Num, Set) of
                true ->
                    get_operation(0, M, N, LeastRate, NP, KeyGen, Set, List); 
                false ->
                    get_operation(0, M-1, N, LeastRate, NP, KeyGen, sets:add_element(Num, Set), [{update, Num, increment, 1}|List])
            end
    end;
get_operation(L, M, N, LeastRate, NP, KeyGen, Set, List) ->
    case sets:size(Set) of
        0 ->
            Num = get_first_key(LeastRate, NP, KeyGen), 
            get_operation(L-1, M, N, LeastRate, NP, KeyGen, sets:add_element(Num, Set), [{read, Num}]);
        _ ->
            Num = get_key(LeastRate, NP, KeyGen), 
            case sets:is_element(Num, Set) of
                true ->
                    get_operation(L, M, N, LeastRate, NP, KeyGen, Set, List); 
                false ->
                    get_operation(L-1, M, N, LeastRate, NP, KeyGen, sets:add_element(Num, Set), [{read, Num}|List])
            end
    end.

get_first_key(LeastRate, NP, KeyGen) ->
    N = random:uniform(100),
    case N =< LeastRate of
        true ->
            %lager:warning("N is ~w, to partition 0", [N]),
            KeyGen()*NP;
        false ->
            Add = random:uniform(NP-1),
            %lager:warning("N is ~w, to partition ~w", [N, Add]),
            KeyGen()*NP+Add
    end. 
    
get_key(_LeastRate, NP, KeyGen) ->
    Add = random:uniform(NP-1),
    %lager:warning("to partition ~w", [Add]),
    KeyGen()*NP+Add.

get_parts([]) ->
    [];
get_parts([{read, Key}|Rest]) ->
    [Key rem 8|get_parts(Rest)];
get_parts([{update, Key, _, _}|Rest]) ->
    [Key rem 8|get_parts(Rest)].

get_start_id(_NP, ignore) ->
    ignore;
get_start_id(NP, StartInStraggler) ->
    N = random:uniform(100),
    case N =< StartInStraggler of
        true ->
            0;
        false ->
            random:uniform(NP-1)+1      
    end.
