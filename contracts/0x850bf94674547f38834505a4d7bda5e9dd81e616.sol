
//Address: 0x850bf94674547f38834505a4d7bda5e9dd81e616
//Contract name: DistributeTokens
//Balance: 0 Ether
//Verification Date: 6/6/2017
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.8;


/*
 * ERC20Basic
 * Simpler version of ERC20 interface
 * see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20Basic {
  uint public totalSupply;
  function balanceOf(address who) constant returns (uint);
  function transfer(address to, uint value);
  event Transfer(address indexed from, address indexed to, uint value);
  function transferFrom(address from, address to, uint value);
  function allowance(address owner, address spender) constant returns (uint);  
}



contract DistributeTokens {
    ERC20Basic public token;
    address owner;
    function DistributeTokens( ERC20Basic _token ) {
        owner = msg.sender;
        token = _token;
    }
    
    function checkExpectedTokens( address[] holdersList, uint[] expectedBalance, uint expectedTotalSupply ) constant returns(uint) {
        uint totalHoldersTokens = 0;
        uint i;
        
        if( token.totalSupply() != expectedTotalSupply ) return 0;
     
        for( i = 0 ; i < holdersList.length ; i++ ) {
            uint holderBalance = token.balanceOf(holdersList[i]);
            if( holderBalance != expectedBalance[i] ) return 0;
            
            totalHoldersTokens += holderBalance;
        }
        
        return totalHoldersTokens;
    }
    
    function distribute( address mainHolder, uint amountToDistribute, address[] holdersList, uint[] expectedBalance, uint expectedTotalSupply ) {
        if( msg.sender != owner ) throw;
        if( token.allowance(mainHolder,this) < amountToDistribute ) throw;
        
     
        uint totalHoldersTokens = checkExpectedTokens(holdersList, expectedBalance, expectedTotalSupply);
        if( totalHoldersTokens == 0 ) throw;
     

        for( uint i = 0 ; i < holdersList.length ; i++ ) {
            uint extraTokens = (amountToDistribute * expectedBalance[i]) / totalHoldersTokens;
            token.transferFrom(mainHolder, holdersList[i], extraTokens);
        }
    }
}
