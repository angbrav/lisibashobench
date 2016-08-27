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
                nodes}).

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

    {ok, #state{nodes=Nodes, worker_id=Id}}.

run(read_txn, KeyGen, _ValueGen, State=#state{worker_id=Id, nodes=Nodes}) ->
    Key = KeyGen(),

    Node = lists:nth((Key rem length(Nodes)+1), Nodes),
    
    Response = rpc:call(Node, antidote, execute_tx, [[{read, Key}]]),
    case Response of
        {ok, {_, CausalClock}} ->
            {ok, State};
        {ok, {_, _, CausalClock}} ->
            {ok, State};
        {error,timeout} ->
            lager:info("Timeout on client ~p",[Id]),
            {error, timeout, State};            
        {error, Reason} ->
            lager:error("Error: ~p",[Reason]),
            {error, Reason, State};
        {badrpc, Reason} ->
            {error, Reason, State}
    end;

run(update_txn, KeyGen, _ValueGen, State=#state{worker_id=Id, nodes=Nodes}) ->
    Node = lists:nth((KeyGen() rem length(Nodes)+1), Nodes),
    Updates = [{update, Key, increment, 1} || Key <- k_unique_numes(25, 1000)],

    Response = rpc:call(Node, antidote, execute_tx, [Updates]),

    case Response of
        {ok, {_, CausalClock}} ->
            lager:info("Success"),
            {ok, State};
        {ok, {_, _, CausalClock}} ->
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
    end.

k_unique_numes(Num, Range) ->
    Seq = lists:seq(1, Num),
    S = lists:foldl(fun(_, Set) ->
                N = uninum(Range, Set),
                 sets:add_element(N, Set)
                end, sets:new(), Seq),
    sets:to_list(S).

uninum(Range, Set) ->
    R = random:uniform(Range),
    case sets:is_element(R, Set) of
        true ->
            uninum(Range, Set);
        false ->
            R
    end.