package org.example.KeepAccounts.service;

import cn.hutool.core.lang.Dict;
import cn.hutool.http.Header;
import cn.hutool.http.HttpRequest;
import cn.hutool.json.JSON;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.example.KeepAccounts.utils.IOUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;


@Service

public class WeBASEService {

    @Value("${system.contract.ContractAddress}")
    String contractAddress;

    public static final String ABI = IOUtil.readResourceAsString("abi/StringGetSet.abi");
    public String adduser(String useraddress,String username) {
        List funcParam = new ArrayList();
        funcParam.add(username);
        funcParam.add(useraddress);
        funcParam.add(1);
        int[] arrayA = new int[]{ 200, 202};//初始化技能
        funcParam.add(arrayA);
        String result = commonReq(useraddress,"addUser",funcParam);
        JSONObject jsonObject = JSONUtil.parseObj(result);
        String dxm = JSONUtil.toJsonStr(jsonObject.get("output"));
        String dxm1 = JSONUtil.toJsonStr(jsonObject.get("input"));
        JSONArray abiJSON = JSONUtil.parseArray(ABI);
        JSONObject data = JSONUtil.createObj();
        data.set("abiList",abiJSON);
        data.set("decodeType",2);
        data.set("input",dxm1);
        data.set("methodName","addUser");
        data.set("output",dxm);
        String dataString = JSONUtil.toJsonStr(data);
//创建httpclient
        CloseableHttpClient httpClient = HttpClients.createDefault();
//post请求方式示例
        HttpPost httpPost = new HttpPost("http://192.168.188.128:5002/WeBASE-Front/tool/decode");
//请求体
        httpPost.setHeader("Content-type","application/json;charset=utf-8");
//设置参数
        StringEntity entity = new StringEntity(dataString, Charset.forName("UTF-8"));
//设置编码格式
        entity.setContentEncoding("UTF-8");
//发送json格式的数据请求
        entity.setContentType("application/json");
//请求消息实体塞进去
        httpPost.setEntity(entity);
//http的post请求
        CloseableHttpResponse httpResponse;
        String result1 = null;

        try {
            httpResponse = httpClient.execute(httpPost);
            result1 = EntityUtils.toString(httpResponse.getEntity(), "UTF-8");
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("output"+result1);
        //将字符串转为json对象
        JSONObject re = JSONUtil.parseObj(result1);
        Set<String> keys= re.keySet();
        JSONArray keyss = JSONUtil.parseArray(keys);
        JSONArray keyss1 = JSONUtil.parseArray(keyss.get(0));
        System.out.println(keyss1);
        String funre = Boolean.toString((Boolean) keyss1.get(0));
//        int funre = (int) keyss1.get(0);
        System.out.println(funre);
        if(funre == "true"){
            System.out.println("注册成功");
            return "注册成功";
        }else{
            System.out.println("注册失败");
            return "注册失败";
        }

    }
////account_removeRole
//    public String account_removeRole( String userAddress,String role,String password) {
//        List funcParam = new ArrayList();
//        funcParam.add(role);
//        funcParam.add(password);
//        funcParam.add(userAddress);
//        String result = commonReq(userAddress,"account_removeRole",funcParam);
//        JSONObject jsonObject = JSONUtil.parseObj(result);
//        String dxm = JSONUtil.toJsonStr(jsonObject.get("output"));
//        String dxm1 = JSONUtil.toJsonStr(jsonObject.get("input"));
//        JSONArray abiJSON = JSONUtil.parseArray(ABI);
//        JSONObject data = JSONUtil.createObj();
//        data.set("abiList",abiJSON);
//        data.set("decodeType",2);
//        data.set("input",dxm1);
//        data.set("methodName","account_removeRole");
//        data.set("output",dxm);
//        String dataString = JSONUtil.toJsonStr(data);
////创建httpclient
//        CloseableHttpClient httpClient = HttpClients.createDefault();
////post请求方式示例
//        HttpPost httpPost = new HttpPost("http://192.168.188.129:5002/WeBASE-Front/tool/decode");
////请求体
//        httpPost.setHeader("Content-type","application/json;charset=utf-8");
////设置参数
//        StringEntity entity = new StringEntity(dataString, Charset.forName("UTF-8"));
////设置编码格式
//        entity.setContentEncoding("UTF-8");
////发送json格式的数据请求
//        entity.setContentType("application/json");
////请求消息实体塞进去
//        httpPost.setEntity(entity);
////http的post请求
//        CloseableHttpResponse httpResponse;
//        String result1 = null;
//
//        try {
//            httpResponse = httpClient.execute(httpPost);
//            result1 = EntityUtils.toString(httpResponse.getEntity(), "UTF-8");
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        System.out.println("output"+result1);
//        //将字符串转为json对象
//        JSONObject re = JSONUtil.parseObj(result1);
//        Set<String> keys= re.keySet();
//        JSONArray keyss = JSONUtil.parseArray(keys);
//        JSONArray keyss1 = JSONUtil.parseArray(keyss.get(0));
//        System.out.println(keyss1);
////        String funre = Boolean.toString((Boolean) keyss1.get(0));
//        int funre = (int) keyss1.get(0);
//        System.out.println(funre);
//        if(funre>0){
//            System.out.println("删除成功");
//            return "删除成功";
//        }else{
//            System.out.println("删除失败");
//            return "删除失败";
//        }
//    }
////account_login
//    public String account_login(String userAddress,String role,String password) {
//        List funcParam = new ArrayList();
//        funcParam.add(role);
//        funcParam.add(password);
//        funcParam.add(userAddress);
//        String result = commonReq(userAddress,"account_login",funcParam);
//
//        return result;
//
//    }
////Assert_put    _Uaddress: 用户地址
////            _Assert： 太阳能板编号
//    public String Assert_put( String uAddress,String Assert){
//        List funcParam = new ArrayList();
//        funcParam.add(uAddress);
//        funcParam.add(Assert);
//        String userAddress=uAddress;
//        String result = commonReq(userAddress,"Assert_put",funcParam);
//        JSONObject jsonObject = JSONUtil.parseObj(result);
//        String dxm = JSONUtil.toJsonStr(jsonObject.get("output"));
//        String dxm1 = JSONUtil.toJsonStr(jsonObject.get("input"));
//        JSONArray abiJSON = JSONUtil.parseArray(ABI);
//        JSONObject data = JSONUtil.createObj();
//        data.set("abiList",abiJSON);
//        data.set("decodeType",2);
//        data.set("input",dxm1);
//        data.set("methodName","account_removeRole");
//        data.set("output",dxm);
//        String dataString = JSONUtil.toJsonStr(data);
////创建httpclient
//        CloseableHttpClient httpClient = HttpClients.createDefault();
////post请求方式示例
//        HttpPost httpPost = new HttpPost("http://192.168.188.129:5002/WeBASE-Front/tool/decode");
////请求体
//        httpPost.setHeader("Content-type","application/json;charset=utf-8");
////设置参数
//        StringEntity entity = new StringEntity(dataString, Charset.forName("UTF-8"));
////设置编码格式
//        entity.setContentEncoding("UTF-8");
////发送json格式的数据请求
//        entity.setContentType("application/json");
////请求消息实体塞进去
//        httpPost.setEntity(entity);
////http的post请求
//        CloseableHttpResponse httpResponse;
//        String result1 = null;
//
//        try {
//            httpResponse = httpClient.execute(httpPost);
//            result1 = EntityUtils.toString(httpResponse.getEntity(), "UTF-8");
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        System.out.println("output"+result1);
//        //将字符串转为json对象
//        JSONObject re = JSONUtil.parseObj(result1);
//        Set<String> keys= re.keySet();
//        JSONArray keyss = JSONUtil.parseArray(keys);
//        JSONArray keyss1 = JSONUtil.parseArray(keyss.get(0));
//        System.out.println(keyss1);
////        String funre = Boolean.toString((Boolean) keyss1.get(0));
//        int funre = (int) keyss1.get(0);
//        System.out.println(funre);
//        if(funre>0){
//            System.out.println("资产添加成功");
//            return "资产添加成功";
//        }else{
//            System.out.println("资产添加失败");
//            return "资产添加失败";
//        }
//    }
//
//    //get_Address_Assert
//    public String get_Address_Assert( String uAddress){
//        List funcParam = new ArrayList();
//        funcParam.add(uAddress);
//        String userAddress="";
//        String result = commonReq(userAddress,"get_Address_Assert",funcParam);
//        return result;
//    }

    public JSONArray getUser(String userAddress) {
        List funcParam = new ArrayList();
        funcParam.add(userAddress);
        String result = commonReq(userAddress,"getUser",funcParam);
        JSONArray  jsonarray= new JSONArray(result);
        return jsonarray;
    }
    public String addjineng(String userAddress,int jnid) {
        List funcParam = new ArrayList();
        funcParam.add(userAddress);
        funcParam.add(jnid);
        String result = commonReq(userAddress,"addjineng",funcParam);
        JSONObject jsonObject = JSONUtil.parseObj(result);
        String dxm = JSONUtil.toJsonStr(jsonObject.get("output"));
        String dxm1 = JSONUtil.toJsonStr(jsonObject.get("input"));
        JSONArray abiJSON = JSONUtil.parseArray(ABI);
        JSONObject data = JSONUtil.createObj();
        data.set("abiList",abiJSON);
        data.set("decodeType",2);
        data.set("input",dxm1);
        data.set("methodName","addjineng");
        data.set("output",dxm);
        String dataString = JSONUtil.toJsonStr(data);
//创建httpclient
        CloseableHttpClient httpClient = HttpClients.createDefault();
//post请求方式示例
        HttpPost httpPost = new HttpPost("http://192.168.188.128:5002/WeBASE-Front/tool/decode");
//请求体
        httpPost.setHeader("Content-type","application/json;charset=utf-8");
//设置参数
        StringEntity entity = new StringEntity(dataString, Charset.forName("UTF-8"));
//设置编码格式
        entity.setContentEncoding("UTF-8");
//发送json格式的数据请求
        entity.setContentType("application/json");
//请求消息实体塞进去
        httpPost.setEntity(entity);
//http的post请求
        CloseableHttpResponse httpResponse;
        String result1 = null;

        try {
            httpResponse = httpClient.execute(httpPost);
            result1 = EntityUtils.toString(httpResponse.getEntity(), "UTF-8");
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("output"+result1);
        //将字符串转为json对象
        JSONObject re = JSONUtil.parseObj(result1);
        Set<String> keys= re.keySet();
        JSONArray keyss = JSONUtil.parseArray(keys);
        JSONArray keyss1 = JSONUtil.parseArray(keyss.get(0));
        System.out.println(keyss1);
        String funre = Boolean.toString((Boolean) keyss1.get(0));
//        int funre = (int) keyss1.get(0);
        System.out.println(funre);
        if(funre == "true"){
            System.out.println("技能添加成功");
            return "技能添加成功";
        }else{
            System.out.println("技能添加失败");
            return "技能添加失败";
        }

    }
    public JSONArray tionjineng(String userAddress,int jnid) {
        List funcParam = new ArrayList();
        funcParam.add(userAddress);
        funcParam.add(jnid);
        commonReq(userAddress,"tionjineng",funcParam);
        return getUser(userAddress);

    }
    public JSONArray addbalances(String userAddress,int _balances) {
        List funcParam = new ArrayList();
        funcParam.add(userAddress);
        funcParam.add(_balances);
        String result = commonReq(userAddress,"addbalances",funcParam);
        JSONObject jsonObject = JSONUtil.parseObj(result);
        String dxm = JSONUtil.toJsonStr(jsonObject.get("output"));
        String dxm1 = JSONUtil.toJsonStr(jsonObject.get("input"));
        JSONArray abiJSON = JSONUtil.parseArray(ABI);
        JSONObject data = JSONUtil.createObj();
        data.set("abiList",abiJSON);
        data.set("decodeType",2);
        data.set("input",dxm1);
        data.set("methodName","addbalances");
        data.set("output",dxm);
        String dataString = JSONUtil.toJsonStr(data);
//创建httpclient
        CloseableHttpClient httpClient = HttpClients.createDefault();
//post请求方式示例
        HttpPost httpPost = new HttpPost("http://192.168.188.128:5002/WeBASE-Front/tool/decode");
//请求体
        httpPost.setHeader("Content-type","application/json;charset=utf-8");
//设置参数
        StringEntity entity = new StringEntity(dataString, Charset.forName("UTF-8"));
//设置编码格式
        entity.setContentEncoding("UTF-8");
//发送json格式的数据请求
        entity.setContentType("application/json");
//请求消息实体塞进去
        httpPost.setEntity(entity);
//http的post请求
        CloseableHttpResponse httpResponse;
        String result1 = null;

        try {
            httpResponse = httpClient.execute(httpPost);
            result1 = EntityUtils.toString(httpResponse.getEntity(), "UTF-8");
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("output"+result1);
        //将字符串转为json对象
        JSONObject re = JSONUtil.parseObj(result1);
        Set<String> keys= re.keySet();
        JSONArray keyss = JSONUtil.parseArray(keys);
        JSONArray keyss1 = JSONUtil.parseArray(keyss.get(0));
//        System.out.println(keyss1);
////        String funre = Boolean.toString((Boolean) keyss1.get(0));
//        int funre = (int) keyss1.get(0);
//        System.out.println(funre);
        return keyss1;

    }
    public JSONArray subbalances(String userAddress,int _balances) {
        List funcParam = new ArrayList();
        funcParam.add(userAddress);
        funcParam.add(_balances);
        String result = commonReq(userAddress,"subbalances",funcParam);
        JSONObject jsonObject = JSONUtil.parseObj(result);
        String dxm = JSONUtil.toJsonStr(jsonObject.get("output"));
        String dxm1 = JSONUtil.toJsonStr(jsonObject.get("input"));
        JSONArray abiJSON = JSONUtil.parseArray(ABI);
        JSONObject data = JSONUtil.createObj();
        data.set("abiList",abiJSON);
        data.set("decodeType",2);
        data.set("input",dxm1);
        data.set("methodName","subbalances");
        data.set("output",dxm);
        String dataString = JSONUtil.toJsonStr(data);
//创建httpclient
        CloseableHttpClient httpClient = HttpClients.createDefault();
//post请求方式示例
        HttpPost httpPost = new HttpPost("http://192.168.188.128:5002/WeBASE-Front/tool/decode");
//请求体
        httpPost.setHeader("Content-type","application/json;charset=utf-8");
//设置参数
        StringEntity entity = new StringEntity(dataString, Charset.forName("UTF-8"));
//设置编码格式
        entity.setContentEncoding("UTF-8");
//发送json格式的数据请求
        entity.setContentType("application/json");
//请求消息实体塞进去
        httpPost.setEntity(entity);
//http的post请求
        CloseableHttpResponse httpResponse;
        String result1 = null;

        try {
            httpResponse = httpClient.execute(httpPost);
            result1 = EntityUtils.toString(httpResponse.getEntity(), "UTF-8");
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("output"+result1);
        //将字符串转为json对象
        JSONObject re = JSONUtil.parseObj(result1);
        Set<String> keys= re.keySet();
        JSONArray keyss = JSONUtil.parseArray(keys);
        JSONArray keyss1 = JSONUtil.parseArray(keyss.get(0));
//        System.out.println(keyss1);
////        String funre = Boolean.toString((Boolean) keyss1.get(0));
//        int funre = (int) keyss1.get(0);
//        System.out.println(funre);
        return keyss1;

    }

    String commonReq(String userAddress, String funcName, List funcParam) {
        JSONArray abiJSON = JSONUtil.parseArray(ABI);
        JSONObject data = JSONUtil.createObj();
        data.set("groupId","1");
        data.set("user",userAddress);
        data.set("contractName","AccountContract");
        data.set("version","");
        data.set("funcName",funcName);
        data.set("funcParam",funcParam);
        data.set("contractAddress",contractAddress);
        data.set("contractAbi",abiJSON);
        data.set("useAes",false);
        data.set("useCns",false);
        data.set("cnsName","");
        String dataString = JSONUtil.toJsonStr(data);
//创建httpclient
        CloseableHttpClient httpClient = HttpClients.createDefault();
//post请求方式示例
        HttpPost httpPost = new HttpPost("http://192.168.188.128:5002/WeBASE-Front/trans/handle");
//请求体
        httpPost.setHeader("Content-type","application/json;charset=utf-8");
//设置参数
        StringEntity entity = new StringEntity(dataString, Charset.forName("UTF-8"));
//设置编码格式
        entity.setContentEncoding("UTF-8");
//发送json格式的数据请求
        entity.setContentType("application/json");
//请求消息实体塞进去
        httpPost.setEntity(entity);
//http的post请求
        CloseableHttpResponse httpResponse;
        String result = null;
        try {
            httpResponse = httpClient.execute(httpPost);
            result = EntityUtils.toString(httpResponse.getEntity(), "UTF-8");
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println("发送POST请求"+result);
        return result;
    }


    public Dict listDeployedContract() {
        JSONObject data = JSONUtil.createObj();
        data.set("groupId","1");
        data.set("contractName","");
        data.set("contractStatus",2);
        data.set("contractAddress","");
        data.set("pageNumber",1);
        data.set("pageSize",10);

        String dataString = JSONUtil.toJsonStr(data);
        String responseBody = HttpRequest.post("http://192.168.188.128:5002/WeBASE-Front/contract/contractList")
                .header(Header.CONTENT_TYPE,"application/json")
                .body(dataString)
                .execute()
                .body();

        JSONObject bodyJSON = JSONUtil.parseObj(responseBody);
        JSONArray constractArray = JSONUtil.parseArray(bodyJSON.get("data"));
        List<Object> retArr = constractArray.stream().map(obj ->{
            JSONObject rawObj = (JSONObject) obj;
            JSONObject json = new JSONObject();
            json.set("合约名称", rawObj.get("contractName"));
            json.set("合约地址", rawObj.get("contractAddress"));
            json.set("部署时间", rawObj.get("deployTime"));
            json.set("创建时间", rawObj.get("createTime"));
            json.set("修改时间", rawObj.get("modifyTime"));
            json.set("abi", rawObj.get("contractAbi"));
            return json;
         }).collect(Collectors.toList());

        Dict retDict = new Dict();
        retDict.set("result",retArr);
        System.out.println("所有合约"+retDict);

        return retDict;
    }

}
