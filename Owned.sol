pragma solidity >=0.4.24;

contract Owned {
    address public owner;
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }
}