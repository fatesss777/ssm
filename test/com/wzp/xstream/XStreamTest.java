package com.wzp.xstream;

import com.thoughtworks.xstream.XStream;
import com.wzp.bean.User;
import org.junit.Test;

public class XStreamTest
{
    @Test
    public void beanToXml()
    {
        User user = new User(1, "哇哇哇", "123");

        XStream xStream = new XStream();
        //起别名
        xStream.alias("user", User.class);
        //将bean转换成xml
        String xml = xStream.toXML(user);
        System.out.println(xml);
    }
}
