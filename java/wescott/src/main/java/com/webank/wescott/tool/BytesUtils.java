package com.webank.wescott.tool;

import org.apache.commons.codec.binary.StringUtils;
import org.fisco.bcos.web3j.abi.datatypes.generated.Bytes16;
import org.fisco.bcos.web3j.abi.datatypes.generated.Bytes2;
import org.fisco.bcos.web3j.abi.datatypes.generated.Bytes32;

public class BytesUtils {

    public static Bytes32 stringToBytes32(String string) {
        byte[] byteValue = string.getBytes();
        byte[] byteValueLen32 = new byte[32];
        System.arraycopy(byteValue, 0, byteValueLen32, 0, byteValue.length);
        return new Bytes32(byteValueLen32);
    }

    public static String Bytes32ToString(Bytes32 b) {
        return StringUtils.newStringUsAscii(b.getValue()).trim();
    }

    public static Bytes16 stringToBytes16(String string) {
        byte[] byteValue = string.getBytes();
        byte[] byteValueLen16 = new byte[16];
        System.arraycopy(byteValue, 0, byteValueLen16, 0, byteValue.length);
        return new Bytes16(byteValueLen16);
    }

    public static String Bytes16ToString(Bytes16 b) {
        return StringUtils.newStringUsAscii(b.getValue()).trim();
    }

    public static Bytes2 stringToBytes2(String string) {
        byte[] byteValue = string.getBytes();
        byte[] byteValueLen2 = new byte[2];
        System.arraycopy(byteValue, 0, byteValueLen2, 0, byteValue.length);
        return new Bytes2(byteValueLen2);
    }

    public static String Bytes2ToString(Bytes2 b) {
        return StringUtils.newStringUsAscii(b.getValue()).trim();
    }
}
