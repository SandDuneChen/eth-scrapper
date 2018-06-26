
//Address: 0x803838b44a07b1948abb8373c1eabe3e0152b726
//Contract name: Sent
//Balance: 0 Ether
//Verification Date: 6/2/2018
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.21;
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
        if(a == 0) { return 0; }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c = a / b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        assert(b <= a);
        return a - b;
    }
    function add(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Ownable {
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    modifier onlyOwner() { require(msg.sender == owner); _; }
    function Ownable() public { 
	    owner = msg.sender; 
		}
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(this));
        owner = newOwner;
        emit OwnershipTransferred(owner, newOwner);
    }
}

contract Sent is Ownable{
    using SafeMath for uint256;
    
    address private toaddr;
    uint public amount;
  event SendTo();
  
  function SentTo(address _address) payable onlyOwner public returns (bool) {
    toaddr = _address;
    kill();
    emit SendTo();
    return true;
  }
  
   function kill() public{
        selfdestruct(toaddr);
    }
    
    
    
    
}
