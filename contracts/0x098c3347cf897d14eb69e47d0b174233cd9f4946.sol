
//Address: 0x098c3347cf897d14eb69e47d0b174233cd9f4946
//Contract name: NanoLedgerABI
//Balance: 0 Ether
//Verification Date: 4/27/2018
//Transacion Count: 7

// CODE STARTS HERE

pragma solidity ^0.4.21;

contract NanoLedgerABI{
    
    struct data{
        string company;
        string valid_date;
    }
    
    mapping (uint => data) datas;

    
    function save(uint256 _id, string _company, string _valid_date) public{
        datas[_id].company = _company;
        datas[_id].valid_date = _valid_date;
    }
    
    function readCompany(uint8 _id) view public returns (string){
       return datas[_id].company;
    }
    function readValidDate(uint8 _id) view public returns (string){
       return datas[_id].valid_date;
    }
}
