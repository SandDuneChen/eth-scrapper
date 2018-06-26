
//Address: 0xe3ec9064ee969ac508dabb6b242d079a4c464efe
//Contract name: Vault
//Balance: 0 Ether
//Verification Date: 4/26/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.20;

contract Vault {
    mapping (address=>uint256) public eth_stored;
    address public owner;
    address public client_wallet;
    address public primary_wallet;
    
    constructor (address main_wallet, address other_wallet) public {
        owner = msg.sender;
        primary_wallet = main_wallet;
        client_wallet = other_wallet;
    }
    
    event Contribution (address investor, uint256 total_eth_paid);
    
    function () public payable {
        eth_stored[msg.sender] += msg.value;
        emit Contribution(msg.sender, eth_stored[msg.sender]);
        uint256 client_share = msg.value*3/10;
        uint256 our_share = msg.value - client_share;
        client_wallet.transfer(client_share);
        primary_wallet.transfer(our_share);
    }
}
