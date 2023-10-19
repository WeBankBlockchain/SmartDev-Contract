// SPDX-License-Identifier: MIT 
pragma solidity ^0.6.12;

import "./User.sol";

contract PersonalItemManager{

    mapping(bytes32 => User) userMap;
    bytes32[] userIDList = new bytes32[](0);

    modifier userExistsOnly(bytes32 _userUUID){
        require(address(userMap[_userUUID]) != address(0),"User doesn't exists");
        _;
    }


    /*
     * Name: register
     * Desc: 注册新用户
     * Param:
     *  @_userName(string)
     * Return: 
     *  @userUUID(bytes32)
     * Note: 用户名不唯一
    **/
    function register(string memory _userName)external returns(bytes32 userUUID){
        User newUser = new User(_userName,userIDList.length);
        userUUID = newUser.getUUID();
        userIDList.push(userUUID);
        userMap[userUUID] = newUser;
        return userUUID;
    }

    /*
     * Name: queryUserIDList
     * Desc: 获取用户UUID列表
     * Return: 
     *  @userIDList(bytes32[])
    **/
    function queryUserIDList()external view returns(bytes32[] memory){
        return userIDList;
    }

    /*
     * Name: queryUserInfo
     * Desc: 查看用户信息
     * Param:
     *  @_userUUID(bytes32)
     * Returns: 
     *  @userName(string)
     *  @userItemAmount(uint256)
    **/
    function queryUserInfo(bytes32 _userUUID)external view userExistsOnly(_userUUID) returns(string memory,uint256){
        return userMap[_userUUID].getInfo();
    }

    /*
     * Name: queryUserItems
     * Desc: 查看用户物品列表
     * Param:
     *  @_userUUID(bytes32)
     * Return: 
     *  @personalItemUUIDList(bytes32[])
    **/
    function queryUserItems(bytes32 _userUUID)external view userExistsOnly(_userUUID) returns(bytes32[] memory){
        return userMap[_userUUID].getPersonalItems();
    }

    /*
     * Name: queryUserItemInfo
     * Desc: 查看用户物品信息
     * Param:
     *  @_ownerUUID(bytes32)
     *  @_itemUUID(bytes32)
     * Return: 
     *  @name(string)
     *  @avaliableUUID(bytes32);
     *  @status(int8)
    **/
    function queryUserItemInfo(bytes32 _ownerUUID,bytes32 _itemUUID)external view userExistsOnly(_ownerUUID) returns(string memory,bytes32,int8){
        return userMap[_ownerUUID].getItemInfo(_itemUUID);
    }

    /*
     * Name: registerPersonalItem
     * Desc: 注册私人物品
     * Param:
     *  @_itemName(string)
     *  @_ownerUUID(bytes32)
     * Return:
     *  @itemUUID(string)
    **/
    function registerPersonalItem(string memory _itemName,bytes32 _ownerUUID)external userExistsOnly(_ownerUUID) returns(bytes32){
        return userMap[_ownerUUID].addPersonalItem(_itemName);
    }

    /*
     * Name: reportPersonalItema
     * Desc: 挂失私人物品
     * Param:
     *  @_ownerUUID(string)
     *  @_itemUUID(bytes32)
     * Return:
     *  @success(bool)
    **/
    function reportPersonalItem(bytes32 _ownerUUID,bytes32 _itemUUID)external userExistsOnly(_ownerUUID) returns(bool){
        return userMap[_ownerUUID].reportPersonalItem(_itemUUID);
    }

    /*
     * Name: retrievePersonalItem
     * Desc: 找回私人物品
     * Param:
     *  @_ownerUUID(string)
     *  @_itemUUID(bytes32)
     * Return:
     *  @success(bool)
    **/
    function retrievePersonalItem(bytes32 _ownerUUID,bytes32 _itemUUID)external userExistsOnly(_ownerUUID) returns(bool){
        return userMap[_ownerUUID].retrievePersonalItem(_itemUUID);
    }

    /*
     * Name: unregisterPersonalItem
     * Desc: 注销私人物品
     * Param:
     *  @_ownerUUID(string)
     *  @_itemUUID(bytes32)
     * Return:
     *  @success(bool)
    **/
    function unregisterPersonalItem(bytes32 _ownerUUID,bytes32 _itemUUID)external userExistsOnly(_ownerUUID) returns(bool){
        return userMap[_ownerUUID].unregisterPersonalItem(_itemUUID);
    }
}