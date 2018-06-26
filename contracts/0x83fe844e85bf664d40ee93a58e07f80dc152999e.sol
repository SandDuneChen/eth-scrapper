
//Address: 0x83fe844e85bf664d40ee93a58e07f80dc152999e
//Contract name: LivroVisitas
//Balance: 0 Ether
//Verification Date: 5/24/2018
//Transacion Count: 6

// CODE STARTS HERE

pragma solidity 0.4.23;


contract Owned {
    address public contractOwner;

    constructor() public { 
        contractOwner = msg.sender; 
    }
    
    function whoIsTheOwner() public view returns(address) {
        return contractOwner;
    }

    function changeOwner(address newOwner) public returns(bool) {
        require(newOwner != address(0));
        if (contractOwner == msg.sender) {
            contractOwner = newOwner;
            return true;
        }
        return false;
    }
}


contract Mortal is Owned  {
    function kill() public {
        if (msg.sender == contractOwner) selfdestruct(contractOwner);
    }
}

contract LivroVisitas is Mortal {
    mapping (address=>string) livro;

    function recordVisit(address visitor, string message) public returns(bool) {
        require(visitor != address(0));
        livro[visitor] = message;
        emit NewVisitor(visitor);
        return true;
    }

    function getMessageOfVisit(address visitor) public view returns(string) {
        if (bytes(livro[visitor]).length > 1) {
            return livro[visitor];
        } else {
            return "";
        }
    }

    event NewVisitor(address visitor);
}
