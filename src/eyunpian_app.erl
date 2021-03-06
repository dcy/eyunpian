%%%-------------------------------------------------------------------
%% @doc eyunpian public API
%% @end
%%%-------------------------------------------------------------------

-module(eyunpian_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    eyunpian_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
