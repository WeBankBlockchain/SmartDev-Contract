// SPDX-License-Identifier: UNLICENSED
/// @author Steve Jin

pragma solidity >=0.8.0;
pragma experimental ABIEncoderV2;

// 导入了 CloneFactory 合约的代码。
import {ICloneFactory} from "./CloneFactory.sol";

// 定义了 IBallot 接口，该接口包含一个 init 方法，用于初始化投票合约。
interface IBallot {
    function init(
        bytes32 _subjectName,
        bytes32[] memory _proposalNames
    ) external;
}

contract BallotFactory {

    // immutable 关键字用于声明一个不可变的变量。声明了一个名为 CLONE_FACTORY 的不可变地址变量。
    address public immutable _CLONE_FACTORY_;

    // 声明了一个名为 _BALLOT_TEMPLATE_ 的投票原型合约的地址
    address public _BALLOT_TEMPLATE_;

    // 合约拥有者
    address public _OWNER_;

    // modifier 关键字用于定义一个函数修饰符。定义了 onlyOwner 修饰符，该修饰符要求只有合约拥有者才能执行修饰的函数。
    modifier onlyOwner() {
        require(msg.sender == _OWNER_, "NOT_OWNER");
        _;
    }

    // 声明了一个构造函数，用于初始化 BallotFactory 合约的状态变量：克隆工厂合约的地址、投票原型合约的地址。
    constructor(
        address cloneFactory,
        address ballotTemplate
    ) {
        _CLONE_FACTORY_ = cloneFactory;
        _BALLOT_TEMPLATE_ = ballotTemplate;
        _OWNER_ = msg.sender;
    }

    // 定义了 createBallot 函数，用于创建一个新的投票合约，并返回新的投票合约的地址。
    // 该行代码使用 onlyOwner 修饰符，要求只有合约拥有者才能调用该函数。
    function createBallot(
        bytes32 _subjectName,
        bytes32[] memory _proposalNames
    ) external payable returns (address newBallot) {
        // 该行代码使用 ICloneFactory 接口，用于调用 CloneFactory 合约中的 clone 方法，创建新的投票合约。
        newBallot = ICloneFactory(_CLONE_FACTORY_).clone(_BALLOT_TEMPLATE_);
        // 该行代码使用 IBallot 接口，用于调用新创建的投票合约的 init 方法，初始化投票合约的信息
        IBallot(newBallot).init(_subjectName, _proposalNames);
    }

    // ============ 管理员操作更新原型合约地址 =============
    function updateBallotTemplate(address newBallotTemplate) external onlyOwner {
        _BALLOT_TEMPLATE_ = newBallotTemplate;
    }
}
