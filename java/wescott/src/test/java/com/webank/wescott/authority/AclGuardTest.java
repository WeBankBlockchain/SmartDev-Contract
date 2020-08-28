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
package com.webank.wescott.authority;

import org.fisco.bcos.web3j.crypto.gm.sm2.util.encoders.Hex;
import org.fisco.bcos.web3j.protocol.core.methods.response.TransactionReceipt;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.webank.wescott.BaseTests;
import com.webank.wescott.contract.authority.WEAclGuard;

/**
 * AclGuardTest
 *
 * @Description: AclGuardTest
 * @author maojiayu
 * @data Feb 17, 2020 4:30:43 PM
 *
 */
public class AclGuardTest extends BaseTests {
    WEAclGuard aclGuard;

    @BeforeEach
    public void deploy() throws Exception {
        aclGuard = WEAclGuard.deploy(web3j, u1, contractGasProvider).send();
    }

    @Test
    public void testOwner() throws Exception {
        String owner = aclGuard._owner().send();
        Assertions.assertEquals(u1.getAddress(), owner);
        aclGuard.setOwner(u2.getAddress()).send();
        String owner2 = aclGuard._owner().send();
        Assertions.assertEquals(u2.getAddress(), owner2);
        TransactionReceipt tr = aclGuard.setOwner(u1.getAddress()).send();
        System.out.println(tr.getStatus());
        Assertions.assertEquals("0x16", tr.getStatus());
        WEAclGuard u2Acl = WEAclGuard.load(aclGuard.getContractAddress(), web3j, u2, contractGasProvider);
        u2Acl.setOwner(u1.getAddress()).send();
        owner = aclGuard._owner().send();
        Assertions.assertEquals(u1.getAddress(), owner);
    }

    @Test
    public void testAuthorized() throws Exception {
        TransactionReceipt tr = aclGuard.setAuthority(aclGuard.getContractAddress()).send();
        System.out.println(tr.getStatus());
        Assertions.assertEquals("0x0", tr.getStatus());
        boolean b = aclGuard.isAuthorized(u1.getAddress(), "0000".getBytes()).send();
        Assertions.assertTrue(b);
        tr = aclGuard.permit(u2.getAddress(), aclGuard.getContractAddress(), "setAuthority(address)").send();
        Assertions.assertEquals("0x0", tr.getStatus());
        WEAclGuard u2Acl = WEAclGuard.load(aclGuard.getContractAddress(), web3j, u2, contractGasProvider);
        tr = u2Acl.setAuthority(aclGuard.getContractAddress()).send();
        Assertions.assertEquals("0x0", tr.getStatus());
    }

    @Test
    public void testCanCall() throws Exception {
        TransactionReceipt tr = aclGuard.permitAny(u2.getAddress(), aclGuard.getContractAddress()).send();
        Assertions.assertEquals("0x0", tr.getStatus());
        boolean b = aclGuard.canCall(u2.getAddress(), aclGuard.getContractAddress(), "0000".getBytes()).send();
        Assertions.assertTrue(b);
        WEAclGuard u2Acl = WEAclGuard.load(aclGuard.getContractAddress(), web3j, u2, contractGasProvider);
        tr = u2Acl.permit(u2.getAddress(), aclGuard.getContractAddress(), "permitAny(address,address)").send();
        Assertions.assertEquals("0x16", tr.getStatus());
        System.out.println("address ANY: " + aclGuard.ANY_ADDRESS().send());

        System.out.println(aclGuard.getContractAddress());
        tr = aclGuard.permit("0xffffffffffffffffffffffffffffffffffffffff", aclGuard.getContractAddress(),
                "permit(address,address,bytes4)").send();
        Assertions.assertEquals("0x0", tr.getStatus());
        tr = aclGuard.setAuthority(aclGuard.getContractAddress()).send();
        System.out.println(tr.getStatus());
        tr = u2Acl.permit("0x1", aclGuard.getContractAddress(), "permit(address,address,bytes4)").send();
        Assertions.assertEquals("0x0", tr.getStatus());
        tr = u2Acl.permitAny("0x2", aclGuard.getContractAddress()).send();
        Assertions.assertEquals("0x0", tr.getStatus());
    }

    @Test
    public void testSig() throws Exception {
        byte[] bytes = aclGuard.getSig().send();
        System.out.println("msg.sig is " + Hex.toHexString(bytes));
        bytes = aclGuard.getSigFromStr("getSig()").send();
        System.out.println("string is  " + Hex.toHexString(bytes));
    }
}
