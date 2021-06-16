pragma solidity^0.4.25;

library Roles{
    struct Role{
        mapping(address=>bool) bearer;
        mapping(address=>string) summary;
    }
    //判断角色
    function has(Role storage role,address amount)internal view returns(bool){
        require(amount!=address(0),"Address is zero address");
        return role.bearer[amount];
    }
    //添加角色
    function add(Role storage role,address amount,string _summary)internal{
        require(!has(role,amount),"Address already exists");
        role.bearer[amount] = true;
        role.summary[amount] = _summary;
    }
    //删除角色
    function remove(Role storage role,address amount)internal{
        require(has(role,amount),"Address does not exist");
        role.bearer[amount] = false;
    }
    //修改角色
    function revise(Role storage role,address amount,string _summary)internal {
        require(has(role,amount),"Address does not exist");
        role.summary[amount] = _summary;
    }
    //查询角色
    function seek(Role storage role,address amount)internal view returns(string){
        require(has(role,amount),"Address does not exist");
        return role.summary[amount];
    }
    
}

contract Character{
    using Roles for Roles.Role;
    Roles.Role private _character;
    
    event characterAdded(address amount,string summary);
    event characterRemoved(address amount);
    event characterRevised(address amount,string summary);
    event characterSeeked(address amount);
    
    address owner;
    address[] characters;
    
    
    constructor()public{
        owner = msg.sender;
    }
    
    modifier onlyOwner(){
        require(owner == msg.sender,"Only owner can call");
        _;
    }
    
    function isCharacter(address amount)public view returns(bool){
        return _character.has(amount);
    }
    
    function _addCharacter(address amount,string _summary)internal{
        _character.add(amount,_summary);
        emit characterAdded(amount,_summary);
    }
    
    function _removeCharacter(address amount)internal{
        _character.remove(amount);
        emit characterRemoved(amount);
    }
    
    function _reviseCharacter(address amount,string _summary)internal{
        _character.revise(amount,_summary);
        emit characterRevised(amount,_summary);
    }
    
    function _seekCharacter(address amount)internal view returns(string){
        return _character.seek(amount);
        emit characterSeeked(amount);
    }
    
    function addCharacter(address amount,string _summary)public onlyOwner{
        require(!isCharacter(amount),"The character already exist");
        characters.push(amount);
        _addCharacter(amount,_summary);
    }
    
    function removeCharacter(address amount)public onlyOwner{
        require(isCharacter(amount),"The character does not exist");
        uint index;
        _removeCharacterByAddress(amount);
        _removeCharacter(amount);
    }
    
    function reviseCharacter(address amount,string _summary)public onlyOwner{
        require(isCharacter(amount),"The character does not exist");
        _reviseCharacter(amount,_summary);
    }
    
    function seekCharacter(address amount)public view returns(string){
        require(isCharacter(amount),"The character does not exist");
        return _seekCharacter(amount);
    }
    
    function _removeCharacterByAddress(address amount)internal view returns(address[]){
        for (uint i = 0; i < characters.length-1; i++) {
            if (amount == characters[i]){
                for (uint j = i; j < characters.length-1; j++) {
                    characters[j] = characters[j+1];
                }
                delete characters[characters.length-1];
                characters.length--;
                return characters;
            }
        }   
    }
    
    function getAllCharater()public view returns(address[]){
        return characters;
    }
    
}
