
//Address: 0xe57e766ab70459d07a46f8a6113317ca4abdb214
//Contract name: EtherealNotes
//Balance: 0 Ether
//Verification Date: 11/10/2017
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity ^0.4.18;

contract EtherealNotes {
    
    string public constant CONTRACT_NAME = "EtherealNotes";
    string public constant CONTRACT_VERSION = "A";
    string public constant QUOTE = "'When you stare into the abyss the abyss stares back at you.' -Friedrich Nietzsche";
    
    event Note(address sender,string indexed note);
    function SubmitNote(string note) public{
        Note(msg.sender, note);
    }
}
