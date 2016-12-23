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
         run/4]).

-include("basho_bench.hrl").

-define(TIMEOUT, 20000).
-record(state, {worker_id,
                time,
                num_updates,
                num_reads,
                clock,
                pb_port,
                target_node,
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
        num_partitions=NumPartitions, skewed_part_rate=SkewedPartRate}}.

run(read_update_txn, KeyGen, _ValueGen, State=#state{nodes=Nodes, key_only_read=KOR, key_only_update=KOU, 
        num_partitions=NP, skewed_part_rate=LeastRate, key_read_update=KRU}) ->
    Node = lists:nth((KeyGen() rem length(Nodes)+1), Nodes),

    ReadUpdates = get_operation(KOR, KOU, KRU, LeastRate, NP, KeyGen, sets:new(), []),

    Metadata = retry_until_commit(Node, ReadUpdates, 0),
    {ok, Metadata, State}.

retry_until_commit(Node, ReadUpdates, Retried) ->
    Response = rpc:call(Node, antidote, execute_tx, [ReadUpdates]),
    case Response of
        {ok, {_, _ReadSet, _CausalClock, TimeWaited, VersionsMissed}} ->
            {TimeWaited, VersionsMissed, Retried};
        %{ok, {_, _ReadSet, _CausalClock}} ->
            %case Retried of 0 -> ok; _ -> lager:warning("Retried ~w times already", [Retried]) end,
        %    {0, [0], Retried};
        {error, _} ->
            retry_until_commit(Node, ReadUpdates, Retried+1)
    end.

get_operation(0, 0, 0, _, _, _, _Set, List) ->
    List;
get_operation(0, 0, N, LeastRate, NP, KeyGen, Set, List) ->
    Num = get_key(LeastRate, NP, KeyGen), 
    %lager:warning("Key is ~w", [Num]),
    case sets:is_element(Num, Set) of
        true ->
            get_operation(0, 0, N, LeastRate, NP, KeyGen, Set, List); 
        false ->
            get_operation(0, 0, N-1, LeastRate, NP, KeyGen, sets:add_element(Num, Set), [{read, Num}, {update, Num, increment, 1}]++List)
    end; 
get_operation(0, M, N, LeastRate, NP, KeyGen, Set, List) ->
    Num = get_key(LeastRate, NP, KeyGen), 
    %lager:warning("Key is ~w", [Num]),
    case sets:is_element(Num, Set) of
        true ->
            get_operation(0, M, N, LeastRate, NP, KeyGen, Set, List); 
        false ->
            get_operation(0, M-1, N, LeastRate, NP, KeyGen, sets:add_element(Num, Set), [{update, Num, increment, 1}|List])
    end; 
get_operation(L, M, N, LeastRate, NP, KeyGen, Set, List) ->
    Num = get_key(LeastRate, NP, KeyGen), 
    case sets:is_element(Num, Set) of
        true ->
            get_operation(L, M, N, LeastRate, NP, KeyGen, Set, List); 
        false ->
            get_operation(L-1, M, N, LeastRate, NP, KeyGen, sets:add_element(Num, Set), [{read, Num}|List])
    end. 

get_key(LeastRate, NP, KeyGen) ->
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
    
