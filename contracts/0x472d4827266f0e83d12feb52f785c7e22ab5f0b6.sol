
//Address: 0x472d4827266f0e83d12feb52f785c7e22ab5f0b6
//Contract name: FileStorage
//Balance: 0 Ether
//Verification Date: 12/8/2016
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.6;
contract FileStorage {	
	address owner;
	mapping (bytes32=>File[]) public files;
	
	struct File {
		string title;		
		string category;	
		string extension;	
		string created;		
		string updated;	
		uint version;	
		bytes data;			
	}

    function FileStorage() {
        owner = msg.sender;
    }
    
    function Kill() {
        if (msg.sender == owner)
        selfdestruct(owner);
    }

	function StoreFile(uint storePrice, bytes32 key, string title, string category, string extension, string created, string updated, uint version, bytes data)
	payable returns (bool success) {
		if (this.balance >= storePrice) {	
			var before = files[key].length;	
			var file = File(title, category, extension, created, updated, version, data);	
			files[key].push(file);	
			
			if (files[key].length > before) {	
				owner.send(this.balance);
				return true;
			} else {
				msg.sender.send(this.balance);
				return false;
			}
		} else {	
			msg.sender.send(this.balance);
			return false;
		}
	}
	
	function GetFileLocation(bytes32 key) constant returns (uint Loc) {
		return files[key].length -1;	
	}
	
	function() {
	    throw;
	}
}
