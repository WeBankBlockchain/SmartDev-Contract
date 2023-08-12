package org.example.KeepAccounts.controller;

import cn.hutool.core.lang.Dict;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.example.KeepAccounts.service.WeBASEService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@Api(value = "WeBASE中记账 Controller", tags = {"WeBASE Api"})
@RestController
@CrossOrigin
@RequestMapping("webase")
public class WeBaseController {

    @Autowired
    WeBASEService service;
//    account_register
    @ApiOperation(value = "智能合约的adduser接口",notes = "智能合约的adduser的接口")
    @RequestMapping(value= "adduser/{address}/{username}", method = RequestMethod.POST)
    public String adduser(@PathVariable("address") String useraddress, @PathVariable("username") String username) {

        return  service.adduser(useraddress,username);
    }
    @ApiOperation(value = "智能合约的getuser接口",notes = "智能合约的getuser的接口")
    @RequestMapping(value= "getuser/{address}", method = RequestMethod.GET)
    public JSONArray getuser(@PathVariable("address") String userAddress) {
        return  service.getUser(userAddress);

    }
//    account_removeRole
    @ApiOperation(value = "智能合约的addjineng接口",notes = "智能合约的addjineng接口")
    @RequestMapping(value= "addjineng/{address}/{jnid}", method = RequestMethod.POST)
    public String addjineng(@PathVariable("address") String userAddress, @PathVariable("jnid") int jnid){
        return  service.addjineng(userAddress,jnid);
}

    @ApiOperation(value = "智能合约的tionjineng接口",notes = "智能合约的tionjineng接口")
    @RequestMapping(value= "tionjineng/{address}/{jnid}", method = RequestMethod.POST)
    public JSONArray tionjineng(@PathVariable("address") String userAddress, @PathVariable("jnid") int jnid){
        return  service.tionjineng(userAddress,jnid);
    }

//    addbalances
    @ApiOperation(value = "智能合约的addbalances接口",notes = "智能合约的addbalances接口")
    @RequestMapping(value= "addbalances/{address}/{balances}", method = RequestMethod.POST)
    public JSONArray addbalances(@PathVariable("address") String userAddress, @PathVariable("balances") int _balances){
    return  service.addbalances(userAddress,_balances);
}
    //    subbalances
    @ApiOperation(value = "智能合约的subbalances接口",notes = "智能合约的subbalances接口")
    @RequestMapping(value= "subbalances/{address}/{balances}", method = RequestMethod.POST)
    public JSONArray subbalances(@PathVariable("address") String userAddress, @PathVariable("balances") int _balances){
        return  service.subbalances(userAddress,_balances);
    }
    @ApiOperation(value = "列出所有已经部署的合约",notes = "列出所有已经部署的合约")
    @RequestMapping(value= "list", method = RequestMethod.GET)
    public Dict listDeployedContract() {
        return  service.listDeployedContract();
    }
}
