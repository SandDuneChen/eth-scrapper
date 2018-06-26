
//Address: 0xc36bdd9a0435f1532499c6a13fcb720bca8bde79
//Contract name: Distributor
//Balance: 0 Ether
//Verification Date: 2/12/2018
//Transacion Count: 60

// CODE STARTS HERE

pragma solidity ^0.4.17;

contract Owned {
    address public owner;
    address public newOwner;

    /**
     * Events
     */
    event ChangedOwner(address indexed new_owner);

    /**
     * Functionality
     */

    function Owned() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function changeOwner(address _newOwner) onlyOwner external {
        newOwner = _newOwner;
    }

    function acceptOwnership() external {
        if (msg.sender == newOwner) {
            owner = newOwner;
            newOwner = 0x0;
            ChangedOwner(owner);
        }
    }
}

contract IOwned {
    function owner() returns (address);
    function changeOwner(address);
    function acceptOwnership();
}

// interface with what we need to withdraw
contract Withdrawable {
	function withdrawTo(address) returns (bool);
}

// responsible for 
contract Distributor is Owned {

	uint256 public nonce;
	Withdrawable public w;

	event BatchComplete(uint256 nonce);

	event Complete();

	function setWithdrawable(address w_addr) onlyOwner {
		w = Withdrawable(w_addr);
	}
	
	function distribute(address[] addrs) onlyOwner {
		for (uint256 i = 0; i <  addrs.length; i++) {
			w.withdrawTo(addrs[i]);
		}
		BatchComplete(nonce);
		nonce = nonce + 1;
	}

	function complete() onlyOwner {
		nonce = 0;
		Complete();
	}
}
