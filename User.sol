// SPDX-License-Identifier: MIT 
pragma solidity ^0.6.12;

import "./PersonalItem.sol";
contract User{
    string userName;                                    //用户名 用于标识
    uint256 personalItemAmount;                         //注册的私人物品数量
    bytes32 uuid;                                       //用户唯一UUID
    bytes32[] personalItemUUIDList = new bytes32[](0);  //用户私人物品UUID列表
    mapping(bytes32 => PersonalItem) personalItemMap;   //用户私人物品映射

    modifier itemExistsOnly(bytes32 itemUUID){
        require(address(personalItemMap[itemUUID]) != address(0),"Personal item doesn't exists");
        _;
    }

    constructor(string memory _userName,uint256 cIndex) public{
        userName = _userName;
        uuid = keccak256(abi.encodePacked((uint256(keccak256(bytes(_userName))) ^ now)+cIndex));
        personalItemAmount = 0;
    }

    //获取账户UUID
    function getUUID()external view returns(bytes32){
        return uuid;
    }

    //获取个人账户信息
    function getInfo()external view returns(string memory,uint256){
        return (userName,personalItemAmount);
    }

    //获取私人物品列表
    function getPersonalItems()external view returns(bytes32[] memory){
        return personalItemUUIDList;
    }

    //获取私人物品详细信息
    function getItemInfo(bytes32 _itemUUID)external view itemExistsOnly(_itemUUID) returns(string memory,bytes32,int8){
        return personalItemMap[_itemUUID].getInfo();
    }

    //注册私人物品
    function addPersonalItem(string memory _itemName)external returns(bytes32 itemUUID){
        PersonalItem newItem = new PersonalItem(_itemName,personalItemUUIDList.length);
        itemUUID = newItem.getUUID();
        personalItemUUIDList.push(itemUUID);
        personalItemMap[itemUUID] = newItem;
        personalItemAmount++;
        return itemUUID;
    }

    //挂失私人物品
    function reportPersonalItem(bytes32 _itemUUID)external itemExistsOnly(_itemUUID) returns(bool){
        return personalItemMap[_itemUUID].report();
    }

    //找回私人物品
    function retrievePersonalItem(bytes32 _itemUUID)external itemExistsOnly(_itemUUID) returns(bool){
        return personalItemMap[_itemUUID].retrieve();
    }

    //注销私人物品
    function unregisterPersonalItem(bytes32 _itemUUID)external itemExistsOnly(_itemUUID) returns(bool result){
        result = personalItemMap[_itemUUID].unregister();
        personalItemAmount--;
        return result;
    }

}