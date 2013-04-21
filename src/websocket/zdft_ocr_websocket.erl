%% @author jackie
%% @doc @todo Add description to zdft_ocr_websocket.

-module(zdft_ocr_websocket).
-behaviour(boss_service_handler).

-record(state,{users}).

%% API
-export([init/0, 
	handle_incoming/5, 
	handle_join/4, 
	handle_close/4, 
	handle_info/2,
	terminate/2]).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init() ->
  io:format("~p (~p) starting...~n", [?MODULE, self()]),
  %timer:send_interval(1000, ping),
  {ok, #state{users=dict:new()}}.

%%--------------------------------------------------------------------
%% to handle a connection to your service
%%--------------------------------------------------------------------
handle_join(_ServiceName, WebSocketId, SessionId, State) ->
    #state{users=Users} = State,
    {reply, ok, #state{users=dict:store(WebSocketId,SessionId,Users)}}.
%%--------------------------------------------------------------------


%%--------------------------------------------------------------------
%% to handle a close connection to you service
%%--------------------------------------------------------------------
handle_close(ServiceName, WebSocketId, _SessionId, State) ->
    #state{users=Users} = State,
    {reply, ok, #state{users=dict:erase(WebSocketId,Users)}}.
%%--------------------------------------------------------------------


%%--------------------------------------------------------------------
%% to handle incoming message to your service
%% here is simple copy to all
%%--------------------------------------------------------------------
handle_incoming(_ServiceName, WebSocketId,_SessionId, Message, State) ->
    %% Message is json
	%% get pid and ocr text
    Json = jsx:parse(Message),
	Pid = proplists:get_value(Json, pid),
	Text = proplists:get_value(Json, text),
	list_to_pid(Pid) ! {ok, Text},
	{reply, ok, State}.
%%--------------------------------------------------------------------


handle_info(ping, State) ->
	error_logger:info_msg("pong:~p~n", [now()]),
	{noreply, State};
handle_info(state, State) ->
    #state{users=Users} = State,
	All = dict:fetch_keys(Users),
	error_logger:info_msg("state:~p~n", [All]),
  {noreply, State};
handle_info({parse, {Pid, Base64Img}, State) ->
	#state{users=Users} = State,
	    Fun = fun(X) when is_pid(X)-> X ! {pid_to_list(Pid), Base64Img} end,
	    All = dict:fetch_keys(Users),
	    [Fun(E) || E <- All, E /= WebSocketId],
  {noreply, State};
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
   %call boss_service:unregister(?SERVER),
  ok.

%% Internal functions

%% ====================================================================
%% Internal functions
%% ====================================================================

