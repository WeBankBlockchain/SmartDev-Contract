// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

struct User {
    address     userAddress;
    bool        isCustomer;
    bool        isServiceProvider;
    bool        isRegistered;
    uint256     creationTime;
}

library UserManagement {
    /// @dev Reverted by `userHasBeenCreated()`.
    bytes4 private constant USER_HAS_BEEN_CREATED_REVERT = 0xd0c98f40;

    /*
     *-------------------------------------------+
     * Bit Location      | Struct                |
     *-------------------------------------------|
     * 0~159 bits        | User Address          |
     * 160 bits          | Customer              |
     * 161 bits          | Service Provider      |
     * 162 bits          | Status(registered)    |
     * 163~193 bits      | Creation time         |
     * 194 bits          | Take Order            |
     *-------------------------------------------+
     */
    uint256 private constant BITMASK_USER = (1 << 160) - 1;
    uint256 private constant BITMASK_COUSTOMER = 160;
    uint256 private constant BITMASK_SERVICE_PROVIDER = 161;
    uint256 private constant BITMASK_STATUS = 162;
    uint256 private constant BITMASK_CREATION_TIME = ((1 << 32) -1) << 193;
    uint256 private constant BITMASK_TAKE_ORDER = 194;

    uint256 private constant CUSTOMER_FLAG = 1;
    uint256 private constant SERVICE_PROVIDER_FLAG = 1;
    uint256 private constant REGISTERED_FLAG = 1;

    /// @dev 
    /// `UsersPackedStorage` is type UsersPackedStorage is uint256 
    struct UsersOperation {
        mapping (address anyUsers => uint256 UsersPackedStorage) usersBitMap;
    }

    /// @dev The `CreateUser` event signature is given by
    /// CreateUser(address indexed users, uint256 creationTime)
    bytes32 private constant _CREATE_EVENT_SIGNATURE = 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06;
                                                        
    function createUser(UsersOperation storage self, User calldata user) internal {
        bool success = true;
        if (getUserRegisterStatus(self, user.userAddress)) success = false;
        if (!user.isCustomer && !user.isServiceProvider) success = false;
        
        uint256 creationTime = block.timestamp;
        // Make user's address the lower 160 bits.
        uint256 userData = uint160(user.userAddress) 
            | (user.isCustomer ? (1 << BITMASK_COUSTOMER) : 0) 
            | (user.isServiceProvider ? (1 << BITMASK_SERVICE_PROVIDER) : 0) 
            | (1 << BITMASK_STATUS) 
            | (creationTime << 193)
            | (1 << BITMASK_TAKE_ORDER);

        // Assign the userData to the user's address in the bitmap
        self.usersBitMap[user.userAddress] = userData;

        assembly("memory-safe") {
            if iszero(success) {
                mstore(0x00, USER_HAS_BEEN_CREATED_REVERT)
                // Revert with [data offset: data size].
                revert(0x00, 0x04)
            }
            log3(0x0, 0x60, _CREATE_EVENT_SIGNATURE, user, creationTime)
        }
    }

    function setTakeOrderStatus(UsersOperation storage self, address user) internal {
        self.usersBitMap[user] |= (1 << BITMASK_TAKE_ORDER);
    }

    function getUserCustomer(UsersOperation storage self, address user) internal view returns (bool) {
        return (self.usersBitMap[user] >> BITMASK_COUSTOMER) & 1 == 1;
    }

    function getUserServiceProvider(UsersOperation storage self, address user) internal view returns (bool) {
        return (self.usersBitMap[user] >> BITMASK_SERVICE_PROVIDER) & 1 == 1;
    }

    function getUserCreationTime(UsersOperation storage self, address user) internal view returns (uint32) {
        return uint32((self.usersBitMap[user] >> 193) & ((1 << 32) - 1));
    }

    function getUserRegisterStatus(UsersOperation storage self, address user) internal view returns (bool) {
        return (self.usersBitMap[user] >> BITMASK_STATUS) & 1 == 1;
    }

    function getTakeOrder(UsersOperation storage self, address user) internal view returns (bool) {
        return (self.usersBitMap[user] >> BITMASK_TAKE_ORDER) & 1 == 1;       
    }
}
