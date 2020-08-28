package com.webank.wescott.tool;

import java.io.InputStream;
import java.security.Key;
import java.security.KeyStore;
import java.security.interfaces.ECPrivateKey;

import org.fisco.bcos.web3j.crypto.Credentials;
import org.fisco.bcos.web3j.crypto.ECKeyPair;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.io.support.ResourcePatternResolver;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CredentialUtils {

    public static Credentials loadKey(String keyStoreFileName, String keyStorePassword, String keyPassword)
            throws Exception {
        KeyStore ks = KeyStore.getInstance("JKS");
        ResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource cdResource = resolver.getResource(keyStoreFileName);
        try (InputStream stream = cdResource.getInputStream()) {
            ks.load(stream, keyStorePassword.toCharArray());
            Key key = ks.getKey("ec", keyPassword.toCharArray());
            ECKeyPair keyPair = ECKeyPair.create(((ECPrivateKey) key).getS());
            Credentials credentials = Credentials.create(keyPair);
            if (credentials != null) {
                return credentials;
            } else {
                log.error("秘钥参数输入有误！");
            }
        }
        return null;
    }

}
