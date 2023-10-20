// SPDX-License-Identifier: MIT 
pragma solidity ^0.6.12;

import "./User.sol";
contract PersonalItem{
    string itemName;            //物品名称，用于标识
    bytes32 uuid;               //物品唯一ID
    bytes32 avaliableUUID;      //物品唯一启用ID，用于辨识丢失物品
    int8 status = -1;           //物品状态 -1:未注册 0：正常 1：挂失 2：注销

    //状态检查：物品非正常
    modifier notAvaliable(){
        require(status != 0,"Personal item is currently normal");
        _;
    }

    //状态检查：物品正常
    modifier avaliableOnly(){
        require(status == 0,"Personal item is currently missing");
        _;
    }

    //状态检查：物品已注册
    modifier registerOnly(){
        require(status != 2,"Personal item has been deregistered");
        _;
    }

    constructor(string memory _itemName,uint256 cIndex) public{
        itemName = _itemName;
        uuid = keccak256(abi.encodePacked((uint256(keccak256(bytes(_itemName))) ^ now)+cIndex));
        generateAvaliableUUID();
        status = 0;
    }

    //获取物品详细信息
    function getInfo()external view returns(string memory,bytes32,int8){
        return (itemName,avaliableUUID,status);
    }

    //获取物品UUID
    function getUUID()external view returns(bytes32){
        return uuid;
    }

    //获取物品启用UUID
    function generateAvaliableUUID()internal registerOnly notAvaliable{
        avaliableUUID = keccak256(abi.encodePacked(uint256(uuid) ^ now));
    }

    //挂失物品
    function report()external registerOnly avaliableOnly returns(bool){
        avaliableUUID = bytes32(0);
        status = 1;
        return true;
    }

    //找回物品
    function retrieve()external registerOnly notAvaliable returns(bool){
        generateAvaliableUUID();
        status = 0;
        return true;
    }

    //注销物品
    function unregister()external registerOnly returns(bool){
        avaliableUUID = bytes32(0);
        status = 2;
        return true;
    }

}