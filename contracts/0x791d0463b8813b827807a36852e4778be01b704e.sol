
//Address: 0x791d0463b8813b827807a36852e4778be01b704e
//Contract name: Test1
//Balance: 0 Ether
//Verification Date: 11/10/2017
//Transacion Count: 6

// CODE STARTS HERE

pragma solidity ^0.4.18;

contract Test1
{
    address owner = msg.sender;
    
    function withdraw()
    payable
    public
    {
        require(msg.sender==owner);
        owner.transfer(this.balance);
    }
    
    function() payable {}
    
    function Test()
    payable
    public
    {
        if(msg.value>=1 ether)
        {
            
            var i1 = 1;
            var i2 = 0;
            var amX2 = msg.value*2;
            
            while(true)
            {
                if(i1<i2)break;
                if(i1>amX2)break;
                
                i2=i1;
                i1++;
            }
            msg.sender.transfer(i2);
        }
    }
}
