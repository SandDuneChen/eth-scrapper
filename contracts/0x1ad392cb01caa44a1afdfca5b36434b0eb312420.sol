
//Address: 0x1ad392cb01caa44a1afdfca5b36434b0eb312420
//Contract name: XG4K
//Balance: 0 Ether
//Verification Date: 12/31/2017
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.4;

/* This currency XG4K/ETH can only be issued by the coiner Xgains4keeps owner of 
the Equity4keeps programme and can be transferred to anyone or entity.
*/

contract XG4K {
    // The keyword "public" makes those variables
    // readable from outside.
    address public coiner;
    mapping (address => uint) public balances;

    // Events allow light clients to react on
    // changes efficiently.
    event Issue(address from, address to, uint amount);

    // This is the constructor whose code is
    // run only when the contract is created.
    function XG4K() public {
        coiner = msg.sender;
        balances[msg.sender] = 100000;
    }

    function mint(address receiver, uint amount) public {
        if (msg.sender != coiner) return;
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) public {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        Issue(msg.sender, receiver, amount);
    }
}
