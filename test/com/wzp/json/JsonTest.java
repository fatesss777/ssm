package com.wzp.json;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wzp.bean.User;
import org.junit.Test;

import java.io.IOException;
import java.util.List;

public class JsonTest
{
    @Test
    public void beanToJson() throws JsonProcessingException
    {
        User user = new User(1, "小鸟", "2233");
        ObjectMapper objectMapper = new ObjectMapper();
        String json = objectMapper.writeValueAsString(user);
        System.out.println(json);
    }


    @Test
    public void jsonToBean() throws IOException
    {
        String json = "[{\"id\":1,\"name\":\"aaa\",\"password\":\"123\"},{\"id\":2,\"name\":\"bbb\",\"password\":\"456\"},{\"id\":3,\"name\":\"ccc\",\"password\":\"789\"}]";
        ObjectMapper objectMapper = new ObjectMapper();
        List<User> list= objectMapper.readValue(json, List.class);
        JsonNode jsonNode = objectMapper.readTree(json);
        System.out.println(jsonNode.get(0).get("name"));
        System.out.println(list);
    }
}
