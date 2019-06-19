pragma solidity ^0.4.24;

contract Passport {
    
    struct User {
        string name;
        string surname;
        uint age;
    }
    
    User[] public users;
    mapping(address => uint) public userAddress; // address to (id + 1)
    address public owner;
    uint public count;
    
    constructor() public {
        count = 1;
    }
    
    function createUser(string _name, string _surname, uint _age) public {
        if (userAddress[msg.sender] == 0) {
            users.push(User(_name, _surname, _age));
            userAddress[msg.sender] = count;
            count++;
        }
    }
}