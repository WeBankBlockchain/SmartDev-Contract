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
package com.webank.wescott.template.point;

import java.math.BigInteger;

import org.fisco.bcos.web3j.protocol.core.methods.response.TransactionReceipt;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.webank.wescott.BaseTests;
import com.webank.wescott.contract.point.Admin;
import com.webank.wescott.contract.point.RewardPointController;
import com.webank.wescott.contract.point.RewardPointData;

/**
 * AdminTest
 *
 * @Description: AdminTest
 * @author maojiayu
 * @data Apr 8, 2020 4:36:44 PM
 *
 */
public class AdminTest extends BaseTests {
    private Admin admin;
    private RewardPointController controller;
    private RewardPointData data;

    @BeforeEach
    public void deploy() throws Exception {
        admin = Admin.deploy(web3j, p1, contractGasProvider).send();
        Assertions.assertNotNull(admin);
        String dataAddress = admin._dataAddress().send();
        Assertions.assertNotNull(dataAddress);
        String controllerAddress = admin._controllerAddress().send();
        Assertions.assertNotNull(controllerAddress);
        controller = RewardPointController.load(controllerAddress, web3j, p1, contractGasProvider);
        data = RewardPointData.load(dataAddress, web3j, p1, contractGasProvider);
    }

    @Test
    public void test() throws Exception {
        TransactionReceipt tr = controller.register().send();
        Assertions.assertEquals("0x0", tr.getStatus());
        tr = controller.issue(p1.getAddress(), BigInteger.valueOf(100)).send();
        Assertions.assertEquals("0x0", tr.getStatus());
        BigInteger balance1 = controller.balance(p1.getAddress()).send();
        Assertions.assertEquals(100, balance1.intValue());

        RewardPointController controllerP2 =
                RewardPointController.load(controller.getContractAddress(), web3j, p2, contractGasProvider);
        tr = controllerP2.register().send();
        Assertions.assertEquals("0x0", tr.getStatus());
        tr = controller.issue(p2.getAddress(), BigInteger.valueOf(200)).send();
        Assertions.assertEquals("0x0", tr.getStatus());
        BigInteger balance2 = controller.balance(p2.getAddress()).send();
        Assertions.assertEquals(200, balance2.intValue());

        // transfer
        tr = controllerP2.transfer(p1.getAddress(), BigInteger.valueOf(50)).send();
        Assertions.assertEquals("0x0", tr.getStatus());
        balance1 = controller.balance(p1.getAddress()).send();
        Assertions.assertEquals(150, balance1.intValue());
        balance2 = controller.balance(p2.getAddress()).send();
        Assertions.assertEquals(150, balance2.intValue());

        // issue
        Assertions.assertTrue(controllerP2.isIssuer(p1.getAddress()).send());
        Assertions.assertTrue(!controllerP2.isIssuer(p2.getAddress()).send());
        tr = controller.addIssuer(p2.getAddress()).send();
        Assertions.assertEquals("0x0", tr.getStatus());
        tr = controllerP2.issue(p2.getAddress(), BigInteger.ONE).send();
        Assertions.assertEquals("0x0", tr.getStatus());
        balance2 = controller.balance(p2.getAddress()).send();
        Assertions.assertEquals(151, balance2.intValue());
        tr = controllerP2.renounceIssuer().send();
        Assertions.assertEquals("0x0", tr.getStatus());
        Assertions.assertTrue(!controllerP2.isIssuer(p2.getAddress()).send());
        BigInteger total = data._totalAmount().send();
        Assertions.assertEquals(301, total.intValue());

        // destroy
        tr = controller.destroy(BigInteger.valueOf(50)).send();
        Assertions.assertEquals("0x0", tr.getStatus());
        balance1 = controller.balance(p1.getAddress()).send();
        Assertions.assertEquals(100, balance1.intValue());
        total = data._totalAmount().send();
        Assertions.assertEquals(251, total.intValue());

        // unregister
        tr = controllerP2.unregister().send();
        Assertions.assertEquals("0x16", tr.getStatus());
        tr = controllerP2.transfer(p1.getAddress(), BigInteger.valueOf(151)).send();
        Assertions.assertEquals("0x0", tr.getStatus());
        tr = controllerP2.unregister().send();
        Assertions.assertEquals("0x0", tr.getStatus());
        Assertions.assertTrue(!data.isIssuer(p2.getAddress()).send());

    }

}
