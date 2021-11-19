/*
 * Copyright 2021 LI LI of JINGTIAN & GONGCHENG.
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
 * */

pragma solidity ^0.4.25;

import "./interfaces/IBookOfShares.sol";
import "./lib/LibSafeMathForUint256Utils.sol";
import "./MembersRepository.sol";
import "./SharesRepository.sol";

/// @title “公司股权簿记系统”智能合约
/// @author 李力@北京市竞天公诚律师事务所
/// @notice 包括《股权登记簿》和《股东名册》两个组成部分。
/// (1) 《股权登记簿》可适用于“有限责任公司”和“股份有限公司”，
/// 在注释中被简称为《股票簿》，相当于公司股份的簿记内档，体现股票（或《出资证明书》）的记载内容。
/// 根据我国《公司法》，可通过《公司章程》确认本智能合约记载的电子数据的法律效力，
/// 使得《股权登记簿》产生设立、变更、撤销股权的直接法律效力（工商登记仅为对抗效力）。
/// 进而以区块链技术，在股东和公司之间搭建专用联盟链，记载《股东名册》和《股权簿记》，
/// 实现公司股权“上链”，通过智能合约实现“自动控制”和“自动化交易”。
/// (2) 《股东名册》按《公司法》逻辑设计，可更新、查询股东持有的股票（或《出资证明回书》）构成、
/// 认缴出资总额、实缴出资总额等信息；
/// (3) 簿记管理人，可设置为外部账户，由特定自然人受托管理（如外聘律师或会计师），
/// 也可以设置为智能合约账户，写入更为复杂的商务、法律逻辑，
/// 从而实现增资、股转等交易的“自动控制”和“原子化”交割;
/// (4) 如果将《公司章程》、《股东协议》等商业、法律逻辑加入,
/// 即可实现对股东权益的直接保护、对股权权益的去中心化、自动化控制。
/// (5) 本系统按照全部“匿名化”逻辑设置，仅“超级管理员”、“簿记管理人”和“股东”等利害关系方
/// 知悉本系统及各账户的主体身份，外部人员无法得知相关地址与主体之间的映射关系。
/// 而且，公司股权簿记信息（发行价、交易价除外），依法需要在“企业信用登记系统”（工商系统）及时对外公示，
/// 因此，本系统即便在公链环境下使用，也并不会给公司、股东带来泄密、数据安全受损的问题。
/// 出于后续开发考虑，本系统预留了各类“交易价格”属性，此类信息不建议在公链或许可链等环境下直接以明文披露，
/// 否则将给相关的利害关系方，造成不可估量的经济损失及负面影响。
contract BookOfShares is IBookOfShares, MembersRepository, SharesRepository {
    using LibSafeMathForUint256Utils for uint256;

    //超级管理员
    address internal _admin;

    //簿记管理人
    address internal _bookkeeper;

    //公司注册号哈希值（统一社会信用号码的“加盐”哈希值）
    bytes32 internal _regNumHash;

    //股权序列号计数器（2**16-1 应该足够计数，因此可考虑uint16）
    uint256 internal _counter;

    //股东人数上限（有限责任公司50人，非公众股份公司200人）
    uint8 internal _maxQtyOfMembers;

    /// @title 公司股权簿记系统的构造函数
    /// @notice 初始化 超级管理员 账户地址，设定 公司股东人数上限， 设定 公司注册号哈希值
    /// @param regNumHash - 公司注册号哈希值
    /// @param maxQtyOfMembers - 公司股东人数上限（根据法定最多股东人数设定）
    constructor(bytes32 regNumHash, uint8 maxQtyOfMembers) public {
        _regNumHash = regNumHash;
        _maxQtyOfMembers = maxQtyOfMembers;
        _admin = msg.sender;
    }

    /// @title 设定 簿记管理人
    /// @notice 设定 簿记管理人
    /// @dev 簿记管理人 可以是外部账户，也可以是智能合约地址（匹配后续开发的《股东协议》《公司章程》等智能合约）
    /// @param bookkeeper - 簿记管理人账户地址
    function setBookkeeper(address bookkeeper) external {
        require(msg.sender == _admin, "仅 系统管理员 有权操作");
        require(bookkeeper != address(0), " 簿记管理人 地址不能为零");
        _bookkeeper = bookkeeper;
    }

    /// @title 查询 簿记管理人 账户地址
    /// @notice 查询 簿记管理人 账户地址
    /// @dev 仅 股东 和 簿记管理人 有权限查询
    /// @return 簿记管理人 账户地址
    function getBookkeeper() external view returns (address) {
        require(
            msg.sender == _bookkeeper || _isMember(msg.sender),
            "仅‘利害关系人’可操作"
        );
        return _bookkeeper;
    }

    /// @title 验证 公司注册号
    /// @notice 输入 公司注册号（加盐） 验证哈希值与 regNumHash 一致性，
    /// 从而确认《股权簿》的公司主体身份
    /// @dev 仅 簿记管理人 和 股东 有权操作
    /// @param regNum - 公司注册号（可加盐）
    /// @return true - 认证通过 ; false - 认证失败
    function verifyRegNum(string regNum) external view returns (bool) {
        require(
            msg.sender == _bookkeeper || _isMember(msg.sender),
            "仅‘利害关系人’可操作"
        );
        return _regNumHash == keccak256(abi.encodePacked(regNum));
    }

    /// @title 查询 股票（出资证明书）序列号计数器当前值
    /// @return 股票序列号计数器当前值
    function getCounter() external view returns (uint256) {
        require(msg.sender == _bookkeeper, "仅 簿记管理人 有权操作");
        return _counter;
    }

    /// @title 发行新股票（签发新的《出资证明书》）
    /// @param shareholder - 股东账户地址
    /// @param class - 股份类别（天使轮、A轮、B轮...）
    /// @param parValue - 股份面值（认缴出资金额，单位为“分”）
    /// @param paidInDeadline - 出资期限（秒计时间戳）
    /// @param issueDate - 签发日期（秒计时间戳）
    /// @param issuePrice - 发行价格（用于判断“反稀释”等价格相关《股东协议》条款,
    /// 公链应用时，出于保密考虑可设置为“1”）
    /// @param obtainedDate - 取得日期（秒计时间戳，受让取得时，与签发日期不同）
    /// @param obtainedPrice - 取得价格（受让取得时，与发行价格不同，
    //// 可用于计算“IRR”、回购收益率等目的，公链应用时，出于保密考虑可设置为“1”）
    /// @param paidInDate - 实缴日期（秒计时间戳）
    /// @param paidInAmount - 实缴金额（实缴出资金额，单位为“分”）
    /// @param state - 股票状态（为质押、查封、信托等特殊安排预留状态变量）
    function issueShare(
        address shareholder,
        uint8 class,
        uint256 parValue,
        uint256 paidInDeadline,
        uint256 issueDate,
        uint256 issuePrice,
        uint256 obtainedDate,
        uint256 obtainedPrice,
        uint256 paidInDate,
        uint256 paidInAmount,
        uint8 state
    ) external {
        require(msg.sender == _bookkeeper, "仅 簿记管理人 有权操作");

        // 判断是否需要添加新股东，若添加是否会超过法定人数上限
        _addMember(shareholder, _maxQtyOfMembers);

        // 股票编号计数器顺加“1”
        _counter = _counter.add(1);

        // 向《股东名册》的“股东”名下添加新股票
        _addShareToMember(shareholder, _counter, parValue, paidInAmount);

        // 在《股权簿》中添加新股票（签发新的《出资证明书》）
        _issueShare(
            _counter,
            shareholder,
            class,
            parValue,
            paidInDeadline,
            issueDate,
            issuePrice,
            obtainedDate,
            obtainedPrice,
            paidInDate,
            paidInAmount,
            state
        );

        // 增加“认缴出资”和“实缴出资”金额
        _capIncrease(parValue, paidInAmount);
    }

    /// @title 实缴出资
    /// @notice 在已经发行的股票项下，实缴出资
    /// @param shareNumber - 股票编号
    /// @param amount - 实缴出资金额（单位“分”）
    /// @param paidInDate - 实缴出资日期（妙计时间戳）
    function payInCapital(
        uint256 shareNumber,
        uint256 amount,
        uint256 paidInDate
    ) external {
        require(msg.sender == _bookkeeper, "仅 簿记管理人 有权操作");

        // 向“股东”名下增加“实缴出资”金额
        _payInCapitalToMember(_shares[shareNumber].shareholder, amount);

        // 增加“股票”项下实缴出资金额
        _payInCapital(shareNumber, amount, paidInDate);

        // 增加公司的“实缴出资”总额
        _capIncrease(0, amount);
    }

    /// @title 转让股份/股票
    /// @notice 先减少原股票金额（金额降低至“0”则删除），再发行新股票
    /// @param shareNumber - 股票编号
    /// @param parValue - 股票面值（认缴出资金额）
    /// @param paidInAmount - 转让的实缴金额（实缴出资金额）
    /// @param to - 受让方账户地址
    /// @param closingDate - 交割日（秒计时间戳）
    /// @param unitPrice - 转让价格（可用于判断“优先权”等条款，公链应用可设定为“1”）
    function transferShare(
        uint256 shareNumber,
        uint256 parValue,
        uint256 paidInAmount,
        address to,
        uint256 closingDate,
        uint256 unitPrice
    ) external {
        require(msg.sender == _bookkeeper, "仅 簿记管理人 有权操作");

        // 减少拟出让股票认缴和实缴金额
        _decreaseShareAmount(shareNumber, parValue, paidInAmount);

        // 判断是否需要新增股东，若需要判断是否超过法定人数上限
        _addMember(to, _maxQtyOfMembers);

        _counter = _counter.add(1);

        // 在“股东”名下增加新的股票
        _addShareToMember(to, _counter, parValue, paidInAmount);

        // 发行新股票
        _issueShare(
            _counter,
            to,
            share.class,
            parValue,
            share.paidInDeadline,
            share.issueDate,
            share.issuePrice,
            closingDate,
            unitPrice,
            share.paidInDate,
            paidInAmount,
            share.state
        );
    }

    /// @title 减少特定“股票”项下认缴和实缴金额
    /// @param shareNumber 拟减资的股票编号
    /// @param parValue 拟减少的认缴出资金额（单位“分”）
    /// @param paidInAmount 拟减少的实缴出资金额（单位“分”）
    function decreaseCapital(
        uint256 shareNumber,
        uint256 parValue,
        uint256 paidInAmount
    ) external {
        require(msg.sender == _bookkeeper, "仅 簿记管理人 有权操作");

        // 减少特定“股票”项下的认缴和实缴金额
        _decreaseShareAmount(shareNumber, parValue, paidInAmount);

        // 减少公司“注册资本”和“实缴出资”总额
        _capDecrease(parValue, paidInAmount);
    }

    /// @title 减少特定“股票”项下认缴和实缴金额
    /// @param shareNumber 拟减资的股票编号
    /// @param parValue 拟减少的认缴出资金额（单位“分”）
    /// @param paidInAmount 拟减少的实缴出资金额（单位“分”）
    function _decreaseShareAmount(
        uint256 shareNumber,
        uint256 parValue,
        uint256 paidInAmount
    ) private {
        Share storage share = _shares[shareNumber];

        require(
            parValue > 0 && parValue <= share.parValue,
            "拟转让‘认缴出资’溢出或标的股权不存在"
        );

        // 若拟降低的面值金额等于股票面值，则删除相关股票
        if (parValue == share.parValue) {
            _removeShareFromMember(
                share.shareholder,
                shareNumber,
                share.parValue,
                share.paidInAmount
            );
            _deregisterShare(shareNumber);
        } else {
            // 仅调低认缴和实缴金额，保留原股票
            _subAmountFromMember(share.shareholder, parValue, paidInAmount);
            _subAmountFromShare(shareNumber, parValue, paidInAmount);
        }
    }

    /// @title 更新特定“股票”的状态
    /// @param shareNumber - 股票编号
    /// @param state - 股票状态（0：正常，1：出质，2：查封，3：已设定信托，4：代持）
    function updateShareState(uint256 shareNumber, uint8 state) external {
        require(msg.sender == _bookkeeper, "仅 簿记管理人 有权操作");
        _updateShareState(shareNumber, state);
    }
}
