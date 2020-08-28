/**
 * Copyright 2014-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.webank.wescott.safemath;

import static org.junit.Assert.assertEquals;
import static org.junit.jupiter.api.Assertions.assertAll;

import java.math.BigInteger;

import org.fisco.bcos.web3j.protocol.core.methods.response.TransactionReceipt;
import org.fisco.bcos.web3j.tx.txdecode.InputAndOutputResult;
import org.fisco.bcos.web3j.tx.txdecode.ResultEntity;
import org.fisco.bcos.web3j.tx.txdecode.TransactionDecoder;
import org.fisco.bcos.web3j.tx.txdecode.TransactionDecoderFactory;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.webank.wescott.BaseTests;
import com.webank.wescott.contract.TestSafeMath;
import com.webank.wescott.tool.JacksonUtils;

/**
 * SafeMathTest
 *
 * @Description: SafeMathTest
 * @author maojiayu
 * @data Feb 7, 2020 4:28:17 PM
 *
 */
public class SafeMathTest extends BaseTests {
    public TestSafeMath safeMath;
    TransactionDecoder txDecodeSampleDecoder =
            TransactionDecoderFactory.buildTransactionDecoder(TestSafeMath.ABI, TestSafeMath.BINARY);

    @BeforeEach
    public void deploy() throws Exception {
        safeMath = TestSafeMath.deploy(web3j, u1, contractGasProvider).send();
    }

    @Test
    public void testAdd() throws Exception {
        TransactionReceipt tr = safeMath.testAdd(BigInteger.valueOf(100), BigInteger.valueOf(1920)).send();
        System.out.println(JacksonUtils.toJson(tr));
        InputAndOutputResult objectResult =
                txDecodeSampleDecoder.decodeOutputReturnObject(tr.getInput(), tr.getOutput());
        ResultEntity entity = objectResult.getResult().get(0);
        BigInteger v = (BigInteger) entity.getData();
        assertAll("entity", () -> assertEquals("uint256", entity.getType()),
                () -> assertEquals(BigInteger.valueOf(2020), v));
    }
    
    public  static void main(String[] args) {
        
        int id = 4 & 1;
        System.out.println(id);
        id |=0;
        System.out.println(id);

        id= id ^ 1;
        System.out.println(id);

    }

}
