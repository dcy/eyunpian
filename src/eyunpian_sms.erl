-module(eyunpian_sms).

%%API
-export([single_send/2, single_send/3,
         batch_send/2, batch_send/3,
         multi_send/2, multi_send/3,
         get_reply/1, get_reply/3, get_reply/4, get_reply/6,
         get_record/1, get_record/3, get_record/4,
         get_black_word/1, get_black_word/2
        ]).

-export([]).

-include_lib("eutil/include/eutil.hrl").
-define(POOL, yunpian_sms).

single_send(Mobile, Text) ->
    Apikey = get_conf_api_key(),
    single_send(Apikey, Mobile, Text).

single_send(Apikey, Mobile, Text) when is_binary(Mobile) andalso is_binary(Text) ->
    Datas = #{apikey => Apikey, mobile => Mobile,
              text => unicode:characters_to_binary(Text)},
    URL = <<"http://sms.yunpian.com/v2/sms/single_send.json">>,
    Result = eutil:http_post(URL, ?URLENCEDED_HEADS, Datas, [{pool, ?POOL}]),
    case maps:get(<<"code">>, Result) of
        ?SUCCESS_0 ->
            ok;
        Code ->
            ?ERROR_MSG("eyunpian_sms single_send error, Mobile: ~p, Result: ~p", [Mobile, Result]),
            {error, Code}
    end.


batch_send(Mobiles, Text) ->
    Apikey = get_conf_api_key(),
    batch_send(Apikey, Mobiles, Text).

batch_send(Apikey, Mobiles, Text) when is_list(Mobiles) ->
    batch_send(Apikey, format_mobiles(Mobiles), Text);
batch_send(Apikey, Mobiles, Text) when is_binary(Mobiles) andalso is_binary(Text) ->
    Datas = #{apikey => Apikey, mobile => Mobiles, text => Text},
    URL = <<"http://sms.yunpian.com/v2/sms/batch_send.json">>,
    Result = eutil:http_post(URL, ?URLENCEDED_HEADS, Datas, [{pool, ?POOL}]),
    case maps:get(<<"data">>, Result, undefined) of
        undefined ->
            ?ERROR_MSG("eyunpian_sms batch_send error, Mobiles: ~p, Result: ~p", [Mobiles, Result]),
            {error, maps:get(<<"code">>, Result)};
        _ ->
            ok
    end.


multi_send(Mobiles, TextList) ->
    Apikey = get_conf_api_key(),
    multi_send(Apikey, Mobiles, TextList).

multi_send(Apikey, Mobiles, Texts) when is_list(Mobiles) andalso is_list(Texts) ->
    multi_send(Apikey, format_mobiles(Mobiles), format_texts(Texts));
multi_send(Apikey, Mobiles, Texts) when is_binary(Mobiles) andalso is_binary(Texts) -> 
    Datas = #{apikey => Apikey, mobile => Mobiles, text => Texts},
    URL = <<"https://sms.yunpian.com/v2/sms/multi_send.json">>,
    Result = eutil:http_post(URL, ?URLENCEDED_HEADS, Datas, [{pool, ?POOL}]),
    case maps:get(<<"data">>, Result, undefined) of
        undefined ->
            ?ERROR_MSG("eyunpian_sms multi_send error, Mobiles: ~p, Result: ~p", [Mobiles, Result]),
            {error, maps:get(<<"code">>, Result)};
        _ ->
            ok
    end.


pull_status() ->
    ok.

pull_reply() ->
    ok.

get_reply(Mobile, StartTime, EndTime) ->
    Apikey = get_conf_api_key(),
    get_reply(Apikey, Mobile, StartTime, EndTime).

get_reply(Apikey, Mobile, StartTime, EndTime) ->
    get_reply(Apikey, Mobile, StartTime, EndTime, 1, 20).

get_reply(Apikey, Mobile, StartTime, EndTime, PageNum, PageSize) ->
    Datas = #{apikey => Apikey, start_time => StartTime, end_time => EndTime,
              page_num => PageNum, page_size => PageSize, mobile => Mobile},
    get_reply(Datas).

get_reply(Datas) ->
    URL = <<"https://sms.yunpian.com/v2/sms/get_reply.json">>,
    eutil:http_post(URL, ?URLENCEDED_HEADS, Datas, [{pool, ?POOL}]).

get_record(Mobile, StartTime, EndTime) ->
    Apikey = get_conf_api_key(),
    get_record(Apikey, Mobile, StartTime, EndTime).

get_record(Apikey, Mobile, StartTime, EndTime) ->
    Datas = #{apikey => Apikey, mobile => Mobile,
              start_time => StartTime, end_time => EndTime},
    get_record(Datas).

get_record(Datas) ->
    URL = <<"https://sms.yunpian.com/v2/sms/get_record.json">>,
    eutil:http_post(URL, ?URLENCEDED_HEADS, Datas, [{pool, ?POOL}]).


get_black_word(Text) ->
    Apikey = get_conf_api_key(),
    get_black_word(Apikey, Text).

get_black_word(Apikey, Text) ->
    URL = <<"https://sms.yunpian.com/v2/sms/get_black_word.json">>,
    Datas = #{apikey => Apikey, text => Text},
    eutil:http_post(URL, ?URLENCEDED_HEADS, Datas, [{pool, ?POOL}]).





get_conf_api_key() ->
    {ok, Apikey} = application:get_env(eyunpian, apikey),
    Apikey.

format_mobiles(Mobiles) when is_list(Mobiles) ->
    Fun = fun(Mobile) ->
                  eutil:to_list(Mobile)
          end,
    list_to_binary(string:join(lists:map(Fun, Mobiles), ",")).

format_texts(Texts) when is_list(Texts) ->
    Fun = fun(Text) ->
                  case is_binary(Text) of
                      true -> unicode:characters_to_list(Text);
                      false -> Text
                  end
          end,
    unicode:characters_to_binary(string:join(lists:map(Fun, Texts), ",")).
