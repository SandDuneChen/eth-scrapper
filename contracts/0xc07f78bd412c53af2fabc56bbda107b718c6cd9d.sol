
//Address: 0xc07f78bd412c53af2fabc56bbda107b718c6cd9d
//Contract name: Test
//Balance: 0 Ether
//Verification Date: 8/25/2017
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.13;

contract Test {

	//address who runs test
	address public owner;

	//max integer result
	uint8 public maxResult;

	function Test() {
		owner = msg.sender;
		maxResult = 100;
	}

	function() {
		revert();
	}

	//get result of random
	function getResult(uint index) constant returns (uint8 a)
	{
		bytes32 blockHash = block.blockhash(index);
		bytes32 shaPlayer = sha3(owner, blockHash);
		a = uint8(uint256(shaPlayer) % maxResult);
	}

	//to check hash in js and in solidity
	function getResultblockHash(bytes32 blockHash) constant returns (uint8 a)
	{
		bytes32 shaPlayer = sha3(owner, blockHash);
		a = uint8(uint256(shaPlayer) % maxResult);
	}
}
