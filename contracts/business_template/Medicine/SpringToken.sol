pragma solidity ^0.4.21;

import "./StandardToken.sol";
import "./Ownable.sol";

/**
 * @title SpringToken
 * @dev ERC20 Token, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */
contract SpringToken is StandardToken, Ownable {

    string public constant name = "SpringToken"; // solium-disable-line uppercase
    string public constant symbol = "SPT"; // solium-disable-line uppercase
    uint8 public constant decimals = 18; // solium-disable-line uppercase

    uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }
}
