
//Address: 0x6c7a3c832e573b1d7f3c9f7d51b2ec13f461dbe1
//Contract name: BitcoinStore
//Balance: 0 Ether
//Verification Date: 5/31/2018
//Transacion Count: 30

// CODE STARTS HERE

pragma solidity ^0.4.11;

contract SafeMath {
  function safeMul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeSub(uint a, uint b) internal returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c>=a && c>=b);
    return c;
  }

  function assert(bool assertion) internal {
    if (!assertion) throw;
  }
}

contract Ownable {
  address public owner;


  /** 
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner. 
   */
  modifier onlyOwner() {
    if (msg.sender != owner) {
      throw;
    }
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to. 
   */
  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}

contract ERC20Basic {
  uint public totalSupply;
  function balanceOf(address who) constant returns (uint);
  function transfer(address to, uint value);
  event Transfer(address indexed from, address indexed to, uint value);
}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) constant returns (uint);
  function transferFrom(address from, address to, uint value);
  function approve(address spender, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}


contract BitcoinStore is Ownable, SafeMath {

  address constant public Bitcoin_address =0xB6eD7644C69416d67B522e20bC294A9a9B405B31;// TESTNET CONTRACT: 0x9D2Cc383E677292ed87f63586086CfF62a009010
  uint bitcoin_ratio = 500*1E8;
  uint eth_ratio = 1*1E18;

  function update_ratio(uint new_bitcoin_ratio, uint new_eth_ratio) 
  onlyOwner
  {
    bitcoin_ratio = new_bitcoin_ratio;
    eth_ratio = new_eth_ratio;
  }

  function send(address _tokenAddr, address dest, uint value)
  onlyOwner
  {
      ERC20(_tokenAddr).transfer(dest, value);
  }

  function multisend(address _tokenAddr, address[] dests, uint[] values)
  onlyOwner
  returns (uint) {
      uint i = 0;
      while (i < dests.length) {
         ERC20(_tokenAddr).transfer(dests[i], values[i]);
         i += 1;
      }
      return(i);
  }

  /* fallback function for when ether is sent to the contract */
  function () external payable {
    uint buytokens = safeMul(bitcoin_ratio , msg.value)/eth_ratio;
    ERC20(Bitcoin_address).transfer(msg.sender, buytokens);
  }

  function buy() public payable {
    uint buytokens = safeMul(bitcoin_ratio , msg.value)/eth_ratio;
    ERC20(Bitcoin_address).transfer(msg.sender, buytokens);
  }

  function withdraw() onlyOwner {
    msg.sender.transfer(this.balance);
  }
}
