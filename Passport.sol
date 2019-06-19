pragma solidity >=0.4.24;
import "./Owned.sol";

contract Passport is Owned {
    
    struct User {
        string name;
        string surname;
        uint age;
        uint id;
    }
    
    User[] public users;
    address public owner;
    uint public count;
    
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }
    
    constructor() public {
        owner = msg.sender;
        count = 0;
    }
    
    function createUser(string _name, string _surname, uint _age) public ownerOnly {
        users.push(User(_name, _surname, _age, count));
        count++;
    }
}