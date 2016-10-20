# eyunpian
> 云片yunpian server sdk for Erlang    
> 集成版本：https://github.com/dcy/epush    
> 使用例子：[/src/eyunpian_example.erl](/src/eyunpian_example.erl)


## single_send 单条发送 
* single_send(Mobile, Text) ->
* single_send(Apikey, Mobile, Text) when is_binary(Mobile) andalso is_binary(Text) ->
```erlang
eyunpian_sms:single_send(<<"15102025006">>, ?TEXT).
```

## batch_send 批量发送
* batch_send(Mobiles, Text) ->
* batch_send(Apikey, Mobiles, Text) when is_list(Mobiles) ->
* batch_send(Apikey, Mobiles, Text) when is_binary(Mobiles) andalso is_binary(Text) ->
```erlang
eyunpian_sms:batch_send(<<"15102025006,15102025005">>, ?TEXT).
eyunpian_sms:batch_send([<<"15102025006">>, <<"15102025005">>], ?TEXT).
```

## multi_send 个性化发送
* multi_send(Mobiles, TextList) ->
* multi_send(Apikey, Mobiles, Texts) when is_list(Mobiles) andalso is_list(Texts) ->
* multi_send(Apikey, Mobiles, Texts) when is_binary(Mobiles) andalso is_binary(Texts) -> 
```erlang
eyunpian_sms:multi_send(?MOBILES, [?TEXT1, ?TEXT2]).
```

## get_reply 查回复的短信
* get_reply(Datas) ->
* get_reply(Mobile, StartTime, EndTime) ->
* get_reply(Apikey, Mobile, StartTime, EndTime) ->
* get_reply(Apikey, Mobile, StartTime, EndTime, PageNum, PageSize) ->
```erlang
eyunpian_sms:get_reply("15102025006", "2016-10-11 00:00:00", "2016-10-21 00:00:00").
%Datas = #{apikey => "yunpian_api_key",
%          start_time => "2016-10-18 00:00:00",
%          end_time => "2016-10-20 00:00:00",
%          %mobile => "15102025006"
%          page_num => 1,
%          page_size => 20
%         },
%eyunpian_sms:get_reply(Datas).
```

## get_record 查短信发送记录
* get_record(Datas) ->
* get_record(Mobile, StartTime, EndTime) ->
* get_record(Apikey, Mobile, StartTime, EndTime) ->
```erlang
eyunpian_sms:get_record("15102025006", "2016-10-18 00:00:00", "2016-10-21 00:00:00").
```

## get_black_word 查屏蔽词
* get_black_word(Text) ->
* get_black_word(Apikey, Text) ->
```erlang
eyunpian_sms:get_black_word(unicode:characters_to_binary("这是一条测试屏蔽词，AV女")).
```


# Todo:
- [ ] pull_status
- [ ] pull_reply

