
//Address: 0xe54420ef4ecda25e08b82a71f72e043f83d7d808
//Contract name: TheRichestMan
//Balance: 0.602000000000000001 Ether
//Verification Date: 2/1/2018
//Transacion Count: 8

// CODE STARTS HERE

contract TheRichestMan {
    address owner;

    address public theRichest;
    uint public treasure=0;
    uint public withdrawDate=0;

    function TheRichestMan(address _owner)
    {
        owner=_owner;
    }

    function () public payable{
        require(treasure < msg.value);
        treasure = msg.value;
        withdrawDate = now + 2 days;
        theRichest = msg.sender;
    }

    function withdraw() public{
        require(now >= withdrawDate);
        require(msg.sender == theRichest);

        //Reset game
        theRichest = 0;
        treasure = 0;

        //taking my 1% from the total prize.
        owner.transfer(this.balance/100);
        
        //reward
        msg.sender.transfer(this.balance);
    }

	// in case of long idling
	function kill() public
	{
		require(msg.sender==owner);
	        require(now >= withdrawDate);
		owner.transfer(this.balance/100);
		suicide(theRichest);
	}
}
