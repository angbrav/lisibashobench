%% -------------------------------------------------------------------
%%
%% riak_bench: Benchmarking Suite for Riak
%%
%% Copyright (c) 2009 Basho Techonologies
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
-module(riak_bench_driver_bitcask).

-export([new/1,
         run/4]).

-include("riak_bench.hrl").

%% ====================================================================
%% API
%% ====================================================================

new(_Id) ->
    %% Make sure bitcask is available
    case code:which(bitcask) of
        non_existing ->
            ?FAIL_MSG("~s requires bitcask to be available on code path.\n",
                      [?MODULE]);
        _ ->
            ok
    end,

    case bitcask:open("test.bitcask", [read_write]) of
        {ok, B} ->
            {ok, B};
        {error, Reason} ->
            ?FAIL_MSG("Failed to open bitcask: ~p\n", [Reason])
    end.



run(get, KeyGen, _ValueGen, State) ->
    case bitcask:get(State, KeyGen()) of
        {ok, _Value, State1} ->
            {ok, State1};
        {not_found, State1} ->
            {ok, State1};
        {error, Reason} ->
            {error, Reason}
    end;
run(put, KeyGen, ValueGen, State) ->
    {ok, State1} = bitcask:put(State, KeyGen(), ValueGen()).
