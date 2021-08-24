pragma solidity^0.4.25;

import "./Roles.sol";

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
        characters.push(amount);
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
    
    function _removeCharacterByAddress(address amount)internal{
        for (uint i = 0; i < characters.length; i++) {
            if (amount == characters[i])
                for (uint j = i; j < characters.length-1; j++) 
                    characters[j] = characters[j+1];
            characters.length--;
            }
    }   
    
    function addCharacter(address amount,string _summary)public onlyOwner{
        require(!isCharacter(amount),"The character already exist");
        _addCharacter(amount,_summary);
    }
    
    function removeCharacter(address amount)public onlyOwner{
        require(isCharacter(amount),"The character does not exist");
        _removeCharacter(amount);
        _removeCharacterByAddress(amount);
    }
    
    function reviseCharacter(address amount,string _summary)public onlyOwner{
        require(isCharacter(amount),"The character does not exist");
        _reviseCharacter(amount,_summary);
    }
    
    function seekCharacter(address amount)public view returns(string) {
        require(isCharacter(amount),"The character does not exist");
        return _seekCharacter(amount);
    }
    
    function getAllCharater()public view returns(address[]){
        return characters;
    }
    
}
