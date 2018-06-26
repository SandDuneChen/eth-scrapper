
//Address: 0x1955a08c4f4e3edc8323b60f792ffc47141538a6
//Contract name: MyFriendships
//Balance: 0 Ether
//Verification Date: 1/4/2018
//Transacion Count: 11

// CODE STARTS HERE

pragma solidity ^0.4.19;

/**
 * @title MyFriendships
 * @dev A contract for managing one's friendships.
 */
contract MyFriendships {
    address public me;
    uint public numberOfFriends;
    address public latestFriend;
    
    mapping(address => bool) myFriends;

    /**
    * @dev Create a contract to keep track of my friendships.
    */
    function MyFriendships() public {
        me = msg.sender;
    }
 
    /**
    * @dev Start an exciting new friendship with me.
    */
    function becomeFriendsWithMe () public {
        require(msg.sender != me); // I won't be friends with myself.
        myFriends[msg.sender] = true;
        latestFriend = msg.sender;
        numberOfFriends++;
    }
    
    /**
    * @dev Am I friends with this address?
    */
    function friendsWith (address addr) public view returns (bool) {
        return myFriends[addr];
    }
}
