// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <=0.6.10;

/**
 * @title Whitelist
 * @author Alberto Cuesta Canada
 * @dev Implements a simple whitelist of addresses.
 */
contract Whitelist {
    event MemberAdded(address member);
    event MemberRemoved(address member);
    address public owner;
    mapping (address => bool) members;

    /**
     * @dev The contract constructor.
     */
    constructor(address _owner) {
        owner = _owner;
    }

    /**
     * @dev A method to verify whether an address is a member of the whitelist
     * @param _member The address to verify.
     * @return Whether the address is a member of the whitelist.
     */
    function isMember(address _member)
        public
        view
        returns(bool)
    {
        return members[_member];
    }
    /**
     * @dev A method to add a member to the whitelist
     * @param _member The member to add as a member.
     */
    function addMember(address _member)
        public
    {
        require(
            !isMember(_member),
            "Address is member already."
        );
        require(
            msg.sender == owner,
            "Caller is not the owner."
        );

        members[_member] = true;
        emit MemberAdded(_member);
    }

    function addMembers(address[] memory _members)
        public
    {
        require(
            msg.sender == owner,
            "Caller is not the owner."
        );
        for (uint i=0; i<_members.length; i++) {
            members[_members[i]] = true;
            emit MemberAdded(_members[i]);
        }
    }

    /**
     * @dev A method to remove a member from the whitelist
     * @param _member The member to remove as a member.
     */
    function removeMember(address _member)
        public
    {
        require(
            isMember(_member),
            "Not member of whitelist."
        );
        require(
            msg.sender == owner,
            "Caller is not the owner."
        );

        delete members[_member];
        emit MemberRemoved(_member);
    }
}
