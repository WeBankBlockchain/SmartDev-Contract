/**
 * Copyright (C) 2018 WeBank, Inc. All Rights Reserved.
 */
package com.webank.wescott.tool;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.fisco.bcos.web3j.abi.datatypes.Address;

/**
 * String2AddressListUtils
 *
 * @Description: String2AddressListUtils
 * @author maojiayu
 * @date 2018年7月9日 下午9:36:06
 * 
 */
public class AddressListUtils {

    public static List<Address> toAddressList(List<String> strList) {
        if (strList.isEmpty()) {
            return new ArrayList<Address>();
        } else {
            return strList.stream().map(str -> {
                return new Address(str);
            }).collect(Collectors.toList());
        }
    }

    public static List<String> addressToStrList(List<Address> adressList) {
        if (adressList.isEmpty()) {
            return new ArrayList<String>();
        } else {
            return adressList.stream().map(addr -> {
                return addr.toString().trim();
            }).collect(Collectors.toList());
        }
    }

}
