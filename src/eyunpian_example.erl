-module(eyunpian_example).
-compile(export_all).

-define(TEXT, unicode:characters_to_binary("【XX科技】验证码1234，请您尽快验证，完成注册。如非本人操作请忽略。")).
-define(TEXT1, unicode:characters_to_binary("【XX科技】验证码1234，请您尽快验证，重置密码。如非本人操作请忽略。")).
-define(MOBILE, <<"15102025006">>).
%-define(MOBILES, <<"15102025006,15102025006">>).
-define(MOBILES, ["15102025006", "15102025006"]).

single_send() ->
    eyunpian_sms:single_send(?MOBILE, ?TEXT).

batch_send() ->
    eyunpian_sms:batch_send(?MOBILES, ?TEXT).

multi_send() ->
    eyunpian_sms:multi_send(?MOBILES, [?TEXT, ?TEXT1]).

get_reply() ->
    eyunpian_sms:get_reply("15102025006", "2016-10-11 00:00:00", "2016-10-21 00:00:00").
    %Datas = #{apikey => "yunpian_api_key",
    %          start_time => "2016-10-18 00:00:00",
    %          end_time => "2016-10-20 00:00:00",
    %          %mobile => "15102025006"
    %          page_num => 1,
    %          page_size => 20
    %         },
    %eyunpian_sms:get_reply(Datas).


get_record() ->
    eyunpian_sms:get_record("15102025006", "2016-10-18 00:00:00", "2016-10-21 00:00:00").

get_black_word() ->
    eyunpian_sms:get_black_word(unicode:characters_to_binary("这是一条测试屏蔽词，AV女")).
