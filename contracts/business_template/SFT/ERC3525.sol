// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./IERC721.sol";//ERC-721接口
import "./IERC3525.sol";//ERC-3525接口
import "./IERC721Receiver.sol";//检测是否实现了721(0x150b7a02)
import "./IERC3525Receiver.sol";//检测是否实现了3525(0x009ce20b)
import "./extensions/IERC721Enumerable.sol";//ERC-721 可选枚举扩展
import "./extensions/IERC721Metadata.sol";//ERC-721 可选元数据扩展
import "./extensions/IERC3525Metadata.sol";//ERC-3525 元数据的可选扩展
import "./interface/IERC3525MetadataDescriptor.sol";//ERC-3525 元数据资源路径
/**
 * @title ERC-3525 Semi-Fungible Token Standard
 * @author 0xSimon
 * @notice https://github.com/solv-finance/erc-3525/blob/main/contracts/ERC3525.sol
 */
contract ERC3525 is Context, IERC3525Metadata, IERC721Enumerable{
    using Strings for address;
    using Strings for uint256;
    using Address for address;
    using Counters for Counters.Counter;//自增器，用于TokenId的自增
    //修改元数据事件
    event SetMetadataDescriptor(address indexed metadataDescriptor);
    //代币数据
    struct TokenData {
        uint256 id;//发行id
        uint256 slot;//属性
        uint256 balance;//余额
        address owner;//拥有者
        address approved;//授权者
        address[] valueApprovals;//被授权使用地址
    }
    //地址数据
    struct AddressData {
        uint256[] ownedTokens;//拥有的tokenID
        mapping(uint256 => uint256) ownedTokensIndex;//key: id
        mapping(address => bool) approvals;//是否授权
    }
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    Counters.Counter private _tokenIdGenerator;//tokenId创建器
    
    // id => (approval => allowance)
    // @dev _approvedValues 无法在 TokenData 中定义，因为无法构建包含映射的结构。
    mapping(uint256 => mapping(address => uint256)) private _approvedValues;

    TokenData[] private _allTokens;

     // key: id
    mapping(uint256 => uint256) private _allTokensIndex;
    //查账户数据
    mapping(address => AddressData) private _addressData;
    //IERC3525元数据描述符
    IERC3525MetadataDescriptor public metadataDescriptor;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
         _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }
    //接口实现检测
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC3525).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC3525Metadata).interfaceId ||
            interfaceId == type(IERC721Enumerable).interfaceId || 
            interfaceId == type(IERC721Metadata).interfaceId;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function valueDecimals() public view virtual override returns (uint8) {
        return _decimals;
    }
     
    //tokenId的余额
    function balanceOf(uint256 tokenId_) public view virtual override returns (uint256) {
        _requireMinted(tokenId_);
        return _allTokens[_allTokensIndex[tokenId_]].balance;
    }
    //tokenId的拥有者
    function ownerOf(uint256 tokenId_) public view virtual override returns (address owner_) {
        _requireMinted(tokenId_);
        owner_ = _allTokens[_allTokensIndex[tokenId_]].owner;
        require(owner_ != address(0), "ERC3525: invalid token ID");
    }
    //tokenId的属性
    function slotOf(uint256 tokenId_) public view virtual override returns (uint256) {
        _requireMinted(tokenId_);
        return _allTokens[_allTokensIndex[tokenId_]].slot;
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
    //返回合约URI
    function contractURI() public view virtual override returns (string memory) {
        string memory baseURI = _baseURI();
        /**
         * 这是一个三元表达式
         * 1.判断metadataDescriptor是否存在
         * 2.存在返回metadataDescriptor.constructContractURI()
         * 3.不存在，判断baseURI是否有长度
         * 4.有长度返回"baseURI"加上"/contract"和"十六进制(当前合约地址)"
         * 否则返回空字符串。
         */
        return 
            address(metadataDescriptor) != address(0) ? 
                metadataDescriptor.constructContractURI() :
                bytes(baseURI).length > 0 ? 
                    string(abi.encodePacked(baseURI, "contract/", Strings.toHexString(address(this)))) : 
                    "";
    }
    //返回属性的URI
    function slotURI(uint256 slot_) public view virtual override returns (string memory) {
        string memory baseURI = _baseURI();
        return 
            address(metadataDescriptor) != address(0) ? 
                metadataDescriptor.constructSlotURI(slot_) : 
                bytes(baseURI).length > 0 ? 
                    string(abi.encodePacked(baseURI, "slot/", slot_.toString())) : 
                    "";
    }
    /**
     * @dev 返回“tokenId”令牌的统一资源标识符 (URI)
     */
    function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
        _requireMinted(tokenId_);
        string memory baseURI = _baseURI();
        return 
            address(metadataDescriptor) != address(0) ? 
                metadataDescriptor.constructTokenURI(tokenId_) : 
                bytes(baseURI).length > 0 ? 
                    string(abi.encodePacked(baseURI, tokenId_.toString())) : 
                    "";
    }
    //授权token的数量
    function approve(uint256 tokenId_, address to_, uint256 value_) public payable virtual override {
        address owner = ERC3525.ownerOf(tokenId_);
        require(to_ != owner, "ERC3525: approval to current owner");

        require(_isApprovedOrOwner(_msgSender(), tokenId_), "ERC3525: approve caller is not owner nor approved");

        _approveValue(tokenId_, to_, value_);
    }
    //查询token授权地址的可调用数量
    function allowance(uint256 tokenId_, address operator_) public view virtual override returns (uint256) {
        _requireMinted(tokenId_);
        return _approvedValues[tokenId_][operator_];
    }
    
    function transferFrom(
        uint256 fromTokenId_,
        address to_,
        uint256 value_
    ) public payable virtual override returns (uint256 newTokenId) {
        _spendAllowance(_msgSender(), fromTokenId_, value_);
        //创建新的tokenId
        newTokenId = _createDerivedTokenId(fromTokenId_);
        _mint(to_, newTokenId, ERC3525.slotOf(fromTokenId_), 0);
        _transferValue(fromTokenId_, newTokenId, value_);
    }
    //转移token的数量
    function transferFrom(
        uint256 fromTokenId_,
        uint256 toTokenId_,
        uint256 value_
    ) public payable virtual override {
        //检测授权
        _spendAllowance(_msgSender(), fromTokenId_, value_);
        //交易tokenId的数量
        _transferValue(fromTokenId_, toTokenId_, value_);
    }

    function balanceOf(address owner_) public view virtual override returns (uint256 balance) {
        require(owner_ != address(0), "ERC3525: balance query for the zero address");
        return _addressData[owner_].ownedTokens.length;
    }
    //转移token
    function transferFrom(
        address from_,
        address to_,
        uint256 tokenId_
    ) public payable virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId_), "ERC3525: transfer caller is not owner nor approved");
        _transferTokenId(from_, to_, tokenId_);
    }
    //转移token，附带data用于REC721检查
    function safeTransferFrom(
        address from_,
        address to_,
        uint256 tokenId_,
        bytes memory data_
    ) public payable virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId_), "ERC3525: transfer caller is not owner nor approved");
        _safeTransferTokenId(from_, to_, tokenId_, data_);
    }
    //转移token，
    function safeTransferFrom(
        address from_,
        address to_,
        uint256 tokenId_
    ) public payable virtual override {
        safeTransferFrom(from_, to_, tokenId_, "");
    }
    //授权token
    function approve(address to_, uint256 tokenId_) public payable virtual override {
        address owner = ERC3525.ownerOf(tokenId_);
        require(to_ != owner, "ERC3525: approval to current owner");

        require(
            _msgSender() == owner || ERC3525.isApprovedForAll(owner, _msgSender()),
            "ERC3525: approve caller is not owner nor approved for all"
        );

        _approve(to_, tokenId_);
    }


    //id查授权
    function getApproved(uint256 tokenId_) public view virtual override returns (address) {
        _requireMinted(tokenId_);
        return _allTokens[_allTokensIndex[tokenId_]].approved;
    }
    //全部授权
    function setApprovalForAll(address operator_, bool approved_) public virtual override {
        _setApprovalForAll(_msgSender(), operator_, approved_);
    }
    //全部授权
    function isApprovedForAll(address owner_, address operator_) public view virtual override returns (bool) {
        return _addressData[owner_].approvals[operator_];
    }
    //合约token的数量
    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }
    //通过index(下标)查找toeknId
    function tokenByIndex(uint256 index_) public view virtual override returns (uint256) {
        require(index_ < ERC3525.totalSupply(), "ERC3525: global index out of bounds");
        return _allTokens[index_].id;
    }
    //通过某个owner的index下标查找的tokenId
    function tokenOfOwnerByIndex(address owner_, uint256 index_) public view virtual override returns (uint256) {
        require(index_ < ERC3525.balanceOf(owner_), "ERC3525: owner index out of bounds");
        return _addressData[owner_].ownedTokens[index_];
    }
    //设置全部授权
    function _setApprovalForAll(
        address owner_,
        address operator_,
        bool approved_
    ) internal virtual {
        require(owner_ != operator_, "ERC3525: approve to caller");

        _addressData[owner_].approvals[operator_] = approved_;

        emit ApprovalForAll(owner_, operator_, approved_);
    }
    //token授权检测
    function _isApprovedOrOwner(address operator_, uint256 tokenId_) internal view virtual returns (bool) {
        address owner = ERC3525.ownerOf(tokenId_);
        return (
            operator_ == owner ||
            ERC3525.isApprovedForAll(owner, operator_) ||
            ERC3525.getApproved(tokenId_) == operator_
        );
    }
    //检测授权，并修改额度
    function _spendAllowance(address operator_, uint256 tokenId_, uint256 value_) internal virtual {
        uint256 currentAllowance = ERC3525.allowance(tokenId_, operator_);
        if (!_isApprovedOrOwner(operator_, tokenId_) && currentAllowance != type(uint256).max) {
            require(currentAllowance >= value_, "ERC3525: insufficient allowance");
            _approveValue(tokenId_, operator_, currentAllowance - value_);
        }
    }
    //检测tokenId是否已经被使用。 创建/使用该TokenId的事件。 如果已经使用，则不计
    function _exists(uint256 tokenId_) internal view virtual returns (bool) {
        //_allTokensIndex[tokenId_]查出数组下标
        //_allTokens[index].id 数组下标的tokenId
        return _allTokens.length != 0 && _allTokens[_allTokensIndex[tokenId_]].id == tokenId_;
    }
    //tokenId已存在，报错
    function _requireMinted(uint256 tokenId_) internal view virtual {
        require(_exists(tokenId_), "ERC3525: invalid token ID");
    }

    //转移Token的数量
    function _transferValue(
        uint256 fromTokenId_,
        uint256 toTokenId_,
        uint256 value_
    ) internal virtual {
        require(_exists(fromTokenId_), "ERC3525: transfer from invalid token ID");
        require(_exists(toTokenId_), "ERC3525: transfer to invalid token ID");

        TokenData storage fromTokenData = _allTokens[_allTokensIndex[fromTokenId_]];
        TokenData storage toTokenData = _allTokens[_allTokensIndex[toTokenId_]];

        require(fromTokenData.balance >= value_, "ERC3525: insufficient balance for transfer");
        require(fromTokenData.slot == toTokenData.slot, "ERC3525: transfer to token with different slot");

        _beforeValueTransfer(
            fromTokenData.owner,
            toTokenData.owner,
            fromTokenId_,
            toTokenId_,
            fromTokenData.slot,
            value_
        );

        fromTokenData.balance -= value_;
        toTokenData.balance += value_;

        emit TransferValue(fromTokenId_, toTokenId_, value_);

        _afterValueTransfer(
            fromTokenData.owner,
            toTokenData.owner,
            fromTokenId_,
            toTokenId_,
            fromTokenData.slot,
            value_
        );

        require(
            _checkOnERC3525Received(fromTokenId_, toTokenId_, value_, ""),
            "ERC3525: transfer rejected by ERC3525Receiver"
        );
    }
    //转移Token
    function _transferTokenId(
        address from_,
        address to_,
        uint256 tokenId_
    ) internal virtual {
        require(ERC3525.ownerOf(tokenId_) == from_, "ERC3525: transfer from invalid owner");
        require(to_ != address(0), "ERC3525: transfer to the zero address");

        uint256 slot = ERC3525.slotOf(tokenId_);
        uint256 value = ERC3525.balanceOf(tokenId_);

        _beforeValueTransfer(from_, to_, tokenId_, tokenId_, slot, value);
        //将token 授权给黑洞地址
        _approve(address(0), tokenId_);
        //清除授权地址
        _clearApprovedValues(tokenId_);
        //删除token拥有者信息
        _removeTokenFromOwnerEnumeration(from_, tokenId_);
        //增加token拥有者信息
        _addTokenToOwnerEnumeration(to_, tokenId_);

        emit Transfer(from_, to_, tokenId_);

        _afterValueTransfer(from_, to_, tokenId_, tokenId_, slot, value);
    }
    //转移Token，检测to地址是否实现ERC721
    function _safeTransferTokenId(
        address from_,
        address to_,
        uint256 tokenId_,
        bytes memory data_
    ) internal virtual {
        _transferTokenId(from_, to_, tokenId_);
        require(
            _checkOnERC721Received(from_, to_, tokenId_, data_),
            "ERC3525: transfer to non ERC721Receiver"
        );
    }

    
    
    //授权token
    function _approve(address to_, uint256 tokenId_) internal virtual {
        _allTokens[_allTokensIndex[tokenId_]].approved = to_;
        emit Approval(ERC3525.ownerOf(tokenId_), to_, tokenId_);
    }
    //tokenid的value授权
    function _approveValue(
        uint256 tokenId_,
        address to_,
        uint256 value_
    ) internal virtual {
        require(to_ != address(0), "ERC3525: approve value to the zero address");
        if (!_existApproveValue(to_, tokenId_)) {
            _allTokens[_allTokensIndex[tokenId_]].valueApprovals.push(to_);
        }
        _approvedValues[tokenId_][to_] = value_;

        emit ApprovalValue(tokenId_, to_, value_);
    }
    //检测tokenid 是否已授权 to
    function _existApproveValue(address to_, uint256 tokenId_) internal view virtual returns (bool) {
        uint256 length = _allTokens[_allTokensIndex[tokenId_]].valueApprovals.length;
        for (uint256 i = 0; i < length; i++) {
            if (_allTokens[_allTokensIndex[tokenId_]].valueApprovals[i] == to_) {
                return true;
            }
        }
        return false;
    }
    //消除所有授权账户
    function _clearApprovedValues(uint256 tokenId_) internal virtual {
        TokenData storage tokenData = _allTokens[_allTokensIndex[tokenId_]];
        uint256 length = tokenData.valueApprovals.length;
        for (uint256 i = 0; i < length; i++) {
            address approval = tokenData.valueApprovals[i];
            delete _approvedValues[tokenId_][approval];
        }
        delete tokenData.valueApprovals;
    }
    //铸造token
    function _mint(address to_, uint256 slot_, uint256 value_) internal virtual returns (uint256 tokenId) {
        //获取tokenId
        tokenId = _createOriginalTokenId();
        _mint(to_, tokenId, slot_, value_);  
    }
    //铸造token 
    function _mint(address to_, uint256 tokenId_, uint256 slot_, uint256 value_) internal virtual {
        require(to_ != address(0), "ERC3525: mint to the zero address");
        require(tokenId_ != 0, "ERC3525: cannot mint zero tokenId");
        require(!_exists(tokenId_), "ERC3525: token already minted");

        _beforeValueTransfer(address(0), to_, 0, tokenId_, slot_, value_);
        //设置token的属性
        __mintToken(to_, tokenId_, slot_);
        //设置token数量
        __mintValue(tokenId_, value_);
        _afterValueTransfer(address(0), to_, 0, tokenId_, slot_, value_);
    }
    //设置token数量
    function _mintValue(uint256 tokenId_, uint256 value_) internal virtual {
        address owner = ERC3525.ownerOf(tokenId_);
        uint256 slot = ERC3525.slotOf(tokenId_);
        _beforeValueTransfer(address(0), owner, 0, tokenId_, slot, value_);
        __mintValue(tokenId_, value_);
        _afterValueTransfer(address(0), owner, 0, tokenId_, slot, value_);
    }
    //设置token数量
    function __mintValue(uint256 tokenId_, uint256 value_) private {
        _allTokens[_allTokensIndex[tokenId_]].balance += value_;
        emit TransferValue(0, tokenId_, value_);
    }
    //设置token属性
    function __mintToken(address to_, uint256 tokenId_, uint256 slot_) private {
        TokenData memory tokenData = TokenData({
            id: tokenId_,
            slot: slot_,
            balance: 0,
            owner: to_,
            approved: address(0),
            valueApprovals: new address[](0)
        });

        _addTokenToAllTokensEnumeration(tokenData);
        _addTokenToOwnerEnumeration(to_, tokenId_);

        emit Transfer(address(0), to_, tokenId_);
        emit SlotChanged(tokenId_, 0, slot_);
    }
    //添加_allTokensIndex，_allTokens中的数据
    function _addTokenToAllTokensEnumeration(TokenData memory tokenData_) private {
        _allTokensIndex[tokenData_.id] = _allTokens.length;
        _allTokens.push(tokenData_);
    }
    //添加_allTokens中的数据
    function _addTokenToOwnerEnumeration(address to_, uint256 tokenId_) private {
        //设置token的拥有者
        _allTokens[_allTokensIndex[tokenId_]].owner = to_;
        //加入ownerToken的索引 
        _addressData[to_].ownedTokensIndex[tokenId_] = _addressData[to_].ownedTokens.length;
        //加入owner的拥有token列表
        _addressData[to_].ownedTokens.push(tokenId_);
    }
    // 在合约中删除Token
    function _removeTokenFromOwnerEnumeration(address from_, uint256 tokenId_) private {
        //移除被删除Token的拥有者
        _allTokens[_allTokensIndex[tokenId_]].owner = address(0);

        AddressData storage ownerData = _addressData[from_];
        uint256 lastTokenIndex = ownerData.ownedTokens.length - 1;
        uint256 lastTokenId = ownerData.ownedTokens[lastTokenIndex];
        uint256 tokenIndex = ownerData.ownedTokensIndex[tokenId_];
        //被删除的token与最后一个token交换位置
        ownerData.ownedTokens[tokenIndex] = lastTokenId;
        ownerData.ownedTokensIndex[lastTokenId] = tokenIndex;
        //删除token
        delete ownerData.ownedTokensIndex[tokenId_];
        ownerData.ownedTokens.pop();
    }
    /**
     * 从所有Token枚举中删除Token
     * @param tokenId_ tokenId_
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId_) private {
        // 为了防止令牌数组中出现间隙，我们将最后一个令牌存储在要删除的令牌的索引中，并且
         // 然后删除最后一个插槽（交换和弹出）。

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId_];

        // 当要删除的token是最后一个token时，不需要swap操作。 然而，由于这种情况发生，所以
         // 很少（当最后一个铸造的代币被销毁时）我们仍然在这里进行交换以避免添加的 gas 成本
         // 'if' 语句（如 _removeTokenFromOwnerEnumeration）
        TokenData memory lastTokenData = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenData; // 将最后一个令牌移动到要删除令牌的槽中
        _allTokensIndex[lastTokenData.id] = tokenIndex; // 更新移动令牌的索引

        // 这也会删除数组最后一个位置的内容
        delete _allTokensIndex[tokenId_];
        _allTokens.pop();
    }
    
    //销毁Token
    function _burn(uint256 tokenId_) internal virtual {
        _requireMinted(tokenId_);

        TokenData storage tokenData = _allTokens[_allTokensIndex[tokenId_]];
        address owner = tokenData.owner;
        uint256 slot = tokenData.slot;
        uint256 value = tokenData.balance;

        _beforeValueTransfer(owner, address(0), tokenId_, 0, slot, value);
        //清除数量
        _clearApprovedValues(tokenId_);
        //删除拥有者
        _removeTokenFromOwnerEnumeration(owner, tokenId_);
        //在allToken数组中删除
        _removeTokenFromAllTokensEnumeration(tokenId_);

        emit TransferValue(tokenId_, 0, value);
        emit SlotChanged(tokenId_, slot, 0);
        emit Transfer(owner, address(0), tokenId_);

        _afterValueTransfer(owner, address(0), tokenId_, 0, slot, value);
    }
    //销毁Token的数量
    function _burnValue(uint256 tokenId_, uint256 burnValue_) internal virtual {
        _requireMinted(tokenId_);

        TokenData storage tokenData = _allTokens[_allTokensIndex[tokenId_]];
        address owner = tokenData.owner;
        uint256 slot = tokenData.slot;
        uint256 value = tokenData.balance;

        require(value >= burnValue_, "ERC3525: burn value exceeds balance");

        _beforeValueTransfer(owner, address(0), tokenId_, 0, slot, burnValue_);

        tokenData.balance -= burnValue_;
        emit TransferValue(tokenId_, 0, burnValue_);
        
        _afterValueTransfer(owner, address(0), tokenId_, 0, slot, burnValue_);
    }

    //检测是否实现ERC3525
        function _checkOnERC3525Received( 
            uint256 fromTokenId_, 
            uint256 toTokenId_, 
            uint256 value_, 
            bytes memory data_
        ) private returns (bool) {
            address to = ERC3525.ownerOf(toTokenId_);
            if (to.isContract() && IERC165(to).supportsInterface(type(IERC3525Receiver).interfaceId)) {
                bytes4 retval = IERC3525Receiver(to).onERC3525Received(_msgSender(), fromTokenId_, toTokenId_, value_, data_);
                return retval == IERC3525Receiver.onERC3525Received.selector;
            } else {
                return true;
            }
        }
    /**
      * @dev 在目标地址上调用 {IERC721Receiver-onERC721Received} 的内部函数。
      * 如果目标地址不是合约，则不执行调用。
      *
      * @param from_ address 表示给定代币 ID 的前任所有者
      * @param to_ 将接收令牌的目标地址
      * @param tokenId_ uint256 要转账的代币ID
      * @param data_ bytes 随调用一起发送的可选数据
      * @return bool 调用是否正确返回了预期的魔法值
      */
    function _checkOnERC721Received(
        address from_,
        address to_,
        uint256 tokenId_,
        bytes memory data_
    ) private returns (bool) {
        if (to_.isContract()) {
            try 
                IERC721Receiver(to_).onERC721Received(_msgSender(), from_, tokenId_, data_) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /* solhint-disable */
    //自定义实现函数
    function _beforeValueTransfer(
        address from_,
        address to_,
        uint256 fromTokenId_,
        uint256 toTokenId_,
        uint256 slot_,
        uint256 value_
    ) internal virtual {}

    function _afterValueTransfer(
        address from_,
        address to_,
        uint256 fromTokenId_,
        uint256 toTokenId_,
        uint256 slot_,
        uint256 value_
    ) internal virtual {}
    /* solhint-enable */

    //修改元数据地址
    function _setMetadataDescriptor(address metadataDescriptor_) internal virtual {
        metadataDescriptor = IERC3525MetadataDescriptor(metadataDescriptor_);
        emit SetMetadataDescriptor(metadataDescriptor_);
    }
    function _createOriginalTokenId() internal virtual returns (uint256) {
        //tokenId自增
         _tokenIdGenerator.increment();
        return _tokenIdGenerator.current();
    }
    function _createDerivedTokenId(uint256 fromTokenId_) internal virtual returns (uint256) {
        fromTokenId_;
        return _createOriginalTokenId();
    }
}