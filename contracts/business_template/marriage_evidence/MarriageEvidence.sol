pragma solidity^0.4.25;
import "./EvidenceFactory.sol";
import "./Character.sol";

contract MarriageEvidence is Character{
    address admin;
    address eviContractAddress;
    address eviAddress;
    constructor() public Character{
        admin = msg.sender;
    }
    
    modifier adminOnly{  
        require(msg.sender == admin ,"require admin");
        _;
    }
    
    modifier charactersMustBeAddedFirst{
        require(getAllCharater().length != 0,"It is null");
        _;
    }
    
    modifier signersOnly{
        require(EvidenceFactory(eviContractAddress).verify(msg.sender),"you not is signer");
        _;
    }
    function deployEvi() external adminOnly charactersMustBeAddedFirst{
        addCharacter(msg.sender,"民政局");
        EvidenceFactory evi = new EvidenceFactory(getAllCharater());
        eviContractAddress = address(evi);
    }
    
    function getSigners() public constant returns(address[]){
        return EvidenceFactory(eviContractAddress).getSigners();
    }
    
    function newEvi(string _evi)public adminOnly returns(address){
        eviAddress = EvidenceFactory(eviContractAddress).newEvidence(_evi);
        return eviAddress;
    }
    
    function sign() public signersOnly returns(bool) {
            return EvidenceFactory(eviContractAddress).addSignatures(eviAddress);
    }
    function getEvi() public constant returns(string,address[],address[]){
            return EvidenceFactory(eviContractAddress).getEvidence(eviAddress);
    }
}