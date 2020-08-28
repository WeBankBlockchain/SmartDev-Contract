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
package com.webank.wescott.config;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.Key;
import java.security.KeyStore;
import java.security.interfaces.ECPrivateKey;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.fisco.bcos.channel.client.Service;
import org.fisco.bcos.channel.handler.ChannelConnections;
import org.fisco.bcos.channel.handler.GroupChannelConnectionsConfig;
import org.fisco.bcos.web3j.crypto.Credentials;
import org.fisco.bcos.web3j.crypto.ECKeyPair;
import org.fisco.bcos.web3j.crypto.EncryptType;
import org.fisco.bcos.web3j.protocol.Web3j;
import org.fisco.bcos.web3j.protocol.channel.ChannelEthereumService;
import org.fisco.bcos.web3j.tx.gas.ContractGasProvider;
import org.fisco.bcos.web3j.tx.gas.StaticGasProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import com.google.common.collect.Lists;
import com.webank.wescott.constant.GasConstants;

import lombok.extern.slf4j.Slf4j;

/**
 * Web3jV2BeanConfig
 *
 * @Description: Web3jV2BeanConfig
 * @author maojiayu
 * @data Apr 16, 2019 11:13:23 AM
 *
 */
@Slf4j
@Configuration
@Order(2)
public class Web3jV2BeanConfig {

    @Autowired
    private SystemEnvironmentConfig systemEnvironmentConfig;

    @Bean
    public Web3j getWeb3j() throws Exception {
        ChannelEthereumService channelEthereumService = new ChannelEthereumService();
        Service service = getService();
        service.run();
        channelEthereumService.setChannelService(service);
        // default sync transactions timeout: 30s
        channelEthereumService.setTimeout(30000);
        return Web3j.build(channelEthereumService, service.getGroupId());
    }

    @Bean
    public Service getService() {
        GroupChannelConnectionsConfig groupChannelConnectionsConfig = getGroupChannelConnections();
        Service channelService = new Service();
        channelService.setOrgID(systemEnvironmentConfig.getOrgId());
        channelService.setGroupId(systemEnvironmentConfig.getGroupId());
        channelService.setAllChannelConnections(groupChannelConnectionsConfig);
        // set some default connect timeout seconds
        channelService.setConnectSeconds(60);
        channelService.setConnectSleepPerMillis(30);

        return channelService;
    }

    @Bean
    public GroupChannelConnectionsConfig getGroupChannelConnections() {
        GroupChannelConnectionsConfig groupChannelConnectionsConfig = new GroupChannelConnectionsConfig();
        ChannelConnections con = new ChannelConnections();
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource ca = resolver.getResource("ca.crt");
        Resource nodeCrt = resolver.getResource("node.crt");
        Resource nodeKey = resolver.getResource("node.key");
        groupChannelConnectionsConfig.setCaCert(ca);
        groupChannelConnectionsConfig.setSslCert(nodeCrt);
        groupChannelConnectionsConfig.setSslKey(nodeKey);
        ArrayList<String> list = new ArrayList<>();
        List<ChannelConnections> allChannelConnections = new ArrayList<>();
        String[] nodes = StringUtils.split(systemEnvironmentConfig.getNodeStr(), ";");
        for (int i = 0; i < nodes.length; i++) {
            if (nodes[i].contains("@")) {
                nodes[i] = StringUtils.substringAfter(nodes[i], "@");
            }
        }
        List<String> nodesList = Lists.newArrayList(nodes);
        list.addAll(nodesList);
        list.stream().forEach(s -> {
            log.info("connect address: {}", s);
        });
        con.setConnectionsStr(list);
        con.setGroupId(systemEnvironmentConfig.getGroupId());
        allChannelConnections.add(con);
        groupChannelConnectionsConfig.setAllChannelConnections(allChannelConnections);
        return groupChannelConnectionsConfig;
    }

    @Bean
    public EncryptType getEncryptType() {
        // 0-RSA 1-Chinese
        return new EncryptType(0);
    }

    @Bean
    public ContractGasProvider getContractGasProvider() {
        return new StaticGasProvider(GasConstants.GAS_PRICE, GasConstants.GAS_LIMIT);
    }
    
    public File loadFile(String filePath, String fileName) throws IOException {
        File file = new File(filePath);
        if (!file.exists()) {
            InputStream stream = getClass().getClassLoader().getResourceAsStream(fileName);
            FileUtils.copyInputStreamToFile(stream, file);
        }
        return file;
    }
    

}
