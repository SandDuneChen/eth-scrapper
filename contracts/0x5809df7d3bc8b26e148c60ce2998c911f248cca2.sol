
//Address: 0x5809df7d3bc8b26e148c60ce2998c911f248cca2
//Contract name: People
//Balance: 0 Ether
//Verification Date: 7/25/2017
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.0;
contract People {
    
    Person[] public people;
    
    struct Person {
        bytes32 firstName;
        bytes32 lastName;
        uint age;
    }
    
    function addPerson(bytes32 _firstname, bytes32 _lastname, uint _age) returns (bool success){
        
        Person memory newPerson;
        newPerson.firstName = _firstname;
        newPerson.lastName = _lastname;
        newPerson.age = _age;
        
        people.push(newPerson);
        return true;
    }
    
    function getPeople() constant returns( bytes32[],bytes32[], uint[]) {
        
        bytes32[] firstNames;
        bytes32[] lastNames;
        uint[] ages;
        
        
        for( uint i = 0; i < people.length; i++){
            Person memory currentPerson;
            currentPerson = people[i];
            firstNames.push(currentPerson.firstName);
            lastNames.push(currentPerson.lastName);
            ages.push(currentPerson.age);
            return (firstNames,lastNames,ages);
        }
    }
}
