
//Address: 0x6324d9d0a23f5ddba165bf8cc61da455350895f2
//Contract name: AddressLottery
//Balance: 0 Ether
//Verification Date: 2/5/2018
//Transacion Count: 7

// CODE STARTS HERE

pragma solidity ^0.4.0;

contract AddressLottery{
    struct SeedComponents{
        uint component1;
        uint component2;
        uint component3;
        uint component4;
    }
    
    address owner;
    uint private secretSeed;
    uint private lastReseed;
    
    uint luckyNumber = 13;
        
    mapping (address => bool) participated;


    function AddressLottery() {
        owner = msg.sender;
        reseed(SeedComponents(12345678, 0x12345678, 0xabbaeddaacdc, 0x333333));
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
  
    function participate() payable { 
        require(msg.value == 0.1 ether);
        
        // every address can only win once, obviously
        require(!participated[msg.sender]);
        
        if ( luckyNumberOfAddress(msg.sender) == luckyNumber)
        {
            participated[msg.sender] = true;
            require(msg.sender.call.value(this.balance)());
        }
    }
    
    function luckyNumberOfAddress(address addr) internal returns(uint n){
        // 1 in 16 chance
        n = uint(keccak256(uint(addr), secretSeed)[0]) % 16;
    }
    
    function reseed(SeedComponents components) internal{
        secretSeed = uint256(keccak256(
            components.component1,
            components.component2,
            components.component3,
            components.component4
        ));
        lastReseed = block.number;
    }
    
    function kill() onlyOwner {
        suicide(owner);
    }
    
    function forceReseed() onlyOwner{
        SeedComponents s;
        s.component1 = uint(msg.sender);
        s.component2 = uint256(block.blockhash(block.number - 1));
        s.component3 = block.number * 1337;
        s.component4 = tx.gasprice * 13;
        reseed(s);
    }
    
    function () payable {}
}
