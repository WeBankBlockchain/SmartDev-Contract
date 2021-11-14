pragma solidity ^0.4.25;

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     *  The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     *  the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     *  Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: not authorized");
        _;
    }

    /**
     *  true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     *  Allows the current owner to transfer control of the contract to a newOwner.
     *  newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     *  Transfers control of the contract to a newOwner.
     *  newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: newOwner not be zero");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
