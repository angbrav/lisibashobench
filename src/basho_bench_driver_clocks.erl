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
                key_per_read_tx,
                key_per_update_tx,
                key_per_read_update_tx}).

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
    KeyPerReadTx  = basho_bench_config:get(key_per_read_tx),
    KeyPerUpdateTx  = basho_bench_config:get(key_per_update_tx),
    KeyPerReadUpdateTx  = basho_bench_config:get(key_per_read_update_tx),

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

    {ok, #state{nodes=Nodes, worker_id=Id, key_per_read_tx=KeyPerReadTx, key_per_update_tx=KeyPerUpdateTx, key_per_read_update_tx=KeyPerReadUpdateTx}}.

run(read_txn, KeyGen, _ValueGen, State=#state{worker_id=Id, nodes=Nodes, key_per_read_tx=KeyPerReadTx}) ->
    Node = lists:nth((KeyGen() rem length(Nodes)+1), Nodes),
    
    L = sets:to_list(lists:foldl(fun(_, Set) ->
                    sets:add_element(KeyGen()+1, Set)
                end, sets:new(), lists:seq(1, KeyPerReadTx))),
    Reads = [{read, Key} || Key <- L],
    
    Response = rpc:call(Node, antidote, execute_tx, [Reads]),
    case Response of
        {ok, {_, _CausalClock}} ->
            lager:info("Read_Success"),
            {ok, State};
        {ok, {_, ReadSet, _CausalClock}} ->
            case read_freshness(ReadSet) of
                0 -> 
                    lager:info("Read Success"),
                    {ok, State};
                F ->
                    lager:error("Not the most recent data. Number of not fresh operation: ~p",[F]),
                    {error, "Not the most recent data.", State}
            end;
        {error,timeout} ->
            lager:info("Timeout on client ~p",[Id]),
            {error, timeout, State};            
        {error, Reason} ->
            lager:error("Error: ~p",[Reason]),
            {error, Reason, State};
        {badrpc, Reason} ->
            {error, Reason, State}
    end;

run(update_txn, KeyGen, _ValueGen, State=#state{worker_id=Id, nodes=Nodes, key_per_update_tx=KeyPerUpdateTx}) ->
    Node = lists:nth((KeyGen() rem length(Nodes)+1), Nodes),

    L = sets:to_list(lists:foldl(fun(_, Set) ->
                 sets:add_element(KeyGen()+1, Set)
                end, sets:new(), lists:seq(1, KeyPerUpdateTx))),
    Updates = [{update, Key, increment, 1} || Key <- L],
    
    Response = rpc:call(Node, antidote, execute_tx, [Updates]),

    case Response of
        {ok, {_, _CausalClock}} ->
            lager:info("Success"),
            {ok, State};
        {ok, {_, _, _CausalClock}} ->
            lager:info("Success"),
            {ok, State};
        {error,timeout} ->
            lager:info("Timeout on client ~p",[Id]),
            {error, timeout, State};            
        {error, Reason} ->
            lager:error("Error: ~p",[Reason]),
            {error, Reason, State};
        error ->
            {error, abort, State};
        {badrpc, Reason} ->
            {error, Reason, State}
    end;

run(read_update_txn, KeyGen, _ValueGen, State=#state{worker_id=Id, nodes=Nodes, key_per_read_update_tx=KeyPerReadUpdateTx}) ->
    Node = lists:nth((KeyGen() rem length(Nodes)+1), Nodes),

    L = sets:to_list(lists:foldl(fun(_, Set) ->
            sets:add_element(KeyGen()+1, Set)
         end, sets:new(), lists:seq(1, KeyPerReadUpdateTx))),

    ReadUpdates = [get_operation(Key) || Key <- L],
    %[lager:info("Operation: ~p", [Op]) || Op <- ReadUpdates],

    Response = rpc:call(Node, antidote, execute_tx, [ReadUpdates]),
    case Response of
        {ok, {_, _CausalClock}} ->
            lager:info("Read_Success"),
            {ok, State};
        {ok, {_, ReadSet, _CausalClock}} ->
	    {ok, State};
            %case read_freshness(ReadSet) of
            %    0 ->
            %        {ok, State};
            %    F ->
            %        lager:error("Not the most recent data. Number of not fresh operation: ~p",[F]),
            %        {error, stale, State}
            %end;
        {error,timeout} ->
            lager:info("Timeout on client ~p",[Id]),
            {error, timeout, State};
        {error, Reason} ->
            lager:error("Error: ~p",[Reason]),
            {error, Reason, State};
        {badrpc, Reason} ->
            {error, Reason, State}
    end.

get_operation(Key) ->
    case Key rem 2 of
        0 ->
            {read, Key};
        1 ->
            {update, Key, increment , 1}
    end.

read_freshness([]) ->
    0;

read_freshness([H|T]) ->
    read_freshness_rec(T,H,0).

read_freshness_rec([], {X, Y}, F) when X /= Y ->
    F0 = F + 1,
    print(X,Y),
    F0;
read_freshness_rec([], _, F) ->
    F;
read_freshness_rec([H|T], {X, Y}, F) when X /= Y ->
    F0 = F + 1,
    print(X,Y),
    read_freshness_rec(T, H, F0);
read_freshness_rec([H|T], _, F) ->
    read_freshness_rec(T, H, F).

print(X,Y) ->
    case X of
        nil ->
            G = Y;
        _ ->
            G = Y-X
    end,
    lager:error("Not the most recent data. Expected ~p but was ~p. Gap: ~p",[Y, X, G]).
