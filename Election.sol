pragma solidity ^0.4.24;
import "./Passport.sol";
import "./Roles.sol";

contract Election is Roles {

    struct Candidate {
        uint id;
        uint voteCount;
    }
    
    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }
    
    string public electionName;
    Candidate[] public candidates;
    uint public totalVotes;
    
    mapping(address => Voter) public voters;
    Passport public passport;
    
    modifier userOnly() {
        require(passport.userAddress(msg.sender) != 0);
        _;
    }
    
    modifier userOrOwner() {
        require(passport.userAddress(msg.sender) != 0 || msg.sender == owner);
        _;
    }
    
    // function startVote() public {
    // }
    
    // function endVote() public {
    // }
    
    constructor(string _name) public {
        owner = msg.sender;
        electionName = _name;
        passport = new Passport();
    }
    
    function addCandidate(uint _id) ownerOnly public {
        if ((passport.count() - 1) > _id) {
            candidates.push(Candidate(_id, 0));    
        }
    } 
    
    function getCandidatesNum() public view returns(uint) {
        return candidates.length;
    }
    
    function authorize(address _person) ownerOnly public {
            voters[_person].authorized = true;
    }
    
    function vote(uint _vote) public {
        require(!voters[msg.sender].voted);
        require(voters[msg.sender].authorized);
        
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = _vote;
        
        candidates[_vote].voteCount++;
        totalVotes++;
    }
    
    function getWinner() public userOrOwner returns(uint) {
        
    }
    
    function terminateVoting() ownerOnly public {
        selfdestruct(owner);
    }
}