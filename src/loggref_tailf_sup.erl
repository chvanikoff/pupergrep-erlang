%% File    : loggref_tailf_sup.erl
%% Author  : Defnull <define.null@gmail.com>
%% Created : 24-08-2012 by Defnull
%% Description : 

-module(loggref_tailf_sup).
-export([]).

-behaviour(supervisor).

%% API
-export([
         start_link/0,
         start_tailf_worker/2,
         stop_tailf_worker/1
        ]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_tailf_worker(Name, Files) ->
    {ok, Pid} = supervisor:start_child(?MODULE, {Name, {loggrep_tailf_worker, start_link, [Name, Files]},
                                              permanent, 2000, worker, [loggrep_tailf_worker]}),
    Pid.

stop_tailf_worker(Name) ->
    ok = supervisor:delete_child(?MODULE, Name),
    loggrep_tailf_worker:stop(Name).


init([]) ->
    SupFlags = {one_for_one, 1000, 3600},
    {ok, {SupFlags, []}}.

    


                                   
