
//Address: 0x477aca6f00b65aee9bbd01a6d43a402c4f914b55
//Contract name: Vault
//Balance: 0 Ether
//Verification Date: 1/14/2018
//Transacion Count: 4

// CODE STARTS HERE

pragma solidity ^0.4.8;

contract Token {
    function balanceOf(address) public constant returns (uint);
    function transfer(address, uint) public returns (bool);
}

contract Vault {
    Token constant public token = Token(0xa645264C5603E96c3b0B078cdab68733794B0A71);
    address constant public recipient = 0x0007013D71C0946126d404Fd44b3B9c97F3418e7;
    // UNIX timestamp
    uint constant public unlockedAt = 1515999600;
    
    function unlock() public {
        if (now < unlockedAt) throw;
        uint vaultBalance = token.balanceOf(address(this));
        token.transfer(recipient, vaultBalance);
    }
}
