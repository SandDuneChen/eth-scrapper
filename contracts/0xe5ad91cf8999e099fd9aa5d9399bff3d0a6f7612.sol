
//Address: 0xe5ad91cf8999e099fd9aa5d9399bff3d0a6f7612
//Contract name: Transfiere2018Database
//Balance: 0 Ether
//Verification Date: 2/20/2018
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity ^0.4.20;

/*************************************************************************************
*
* Transfiere 2018 Database
* Property of FYCMA
* Powered by TICsmart
* Description: 
* Smart Contract of attendance at the event and forum Transfiere 2018
*
**************************************************************************************/

contract Transfiere2018Database {
  struct Organization {
    string codigo;
    string nombre;
    string tipo;
  }

  Organization[] internal availableOrgs;
  address public owner = msg.sender;

  function addOrg(string _codigo, string _nombre, string _tipo) public {
    require(msg.sender == owner);
    availableOrgs.push(Organization(_codigo, _nombre, _tipo));
  }

  function deleteOrg(string _codigo) public {
    require(msg.sender == owner);

    for (uint i = 0; i < availableOrgs.length; i++) {
      if (keccak256(availableOrgs[i].codigo) == keccak256(_codigo)) {
        delete availableOrgs[i];
      }
    }
  }

  function numParticipants() public view returns (uint) {
    return availableOrgs.length;
  }
  
  function checkCode(string _codigo) public view returns (string, string) {
    for (uint i = 0; i < availableOrgs.length; i++) {
      if (keccak256(availableOrgs[i].codigo) == keccak256(_codigo)) {
          return (availableOrgs[i].nombre, availableOrgs[i].tipo);
      }
    }
    
    return (_codigo,"The codigo no existe.");
  }
  
  function destroy() public {
      require(msg.sender == owner);
      selfdestruct(owner);
  }
}
