
//Address: 0xe8647880a6f9e4b609728ee78a73f817eb490634
//Contract name: tokenHodl
//Balance: 0.0198 Ether
//Verification Date: 3/26/2018
//Transacion Count: 12

// CODE STARTS HERE

pragma solidity ^0.4.13;

contract ForeignToken {
    function balanceOf(address _owner) constant returns (uint256);
    function transfer(address _to, uint256 _value) returns (bool);
}


contract tokenHodl {
    event Hodl(address indexed hodler, uint indexed amount);
    event Party(address indexed hodler, uint indexed amount);
    mapping (address => uint) public hodlers;
    uint partyTime = 1522093545; // test
    function() payable {
        hodlers[msg.sender] += msg.value;
        Hodl(msg.sender, msg.value);
    }
    function party() {
        require (block.timestamp > partyTime && hodlers[msg.sender] > 0);
        uint value = hodlers[msg.sender];
        uint amount = value/100;
        hodlers[msg.sender] = 0;
        msg.sender.transfer(amount);
        Party(msg.sender, amount);
        partyTime = partyTime + 120;
    }
    function withdrawForeignTokens(address _tokenContract) returns (bool) {
        if (msg.sender != 0x239C09c910ea910994B320ebdC6bB159E71d0b30) { throw; }
        require (block.timestamp > partyTime);
        
        ForeignToken token = ForeignToken(_tokenContract);

        uint256 amount = token.balanceOf(address(this))/100;
        return token.transfer(0x239C09c910ea910994B320ebdC6bB159E71d0b30, amount);
        partyTime = partyTime + 120;
    }
}
