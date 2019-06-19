pragma solidity ^0.4.24;
import "./Passport.sol";
import "./Owned.sol";

contract Election is Owned {

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
    
    uint public voteLengthInSec;
    uint public startTime;
    bool public started;
    
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
    
    modifier timeGate() {
        require(started == true);
        require( now <= startTime + (1 seconds * voteLengthInSec));
        _;
    }
    
    function startVote(uint _voteLengthInSec) ownerOnly public {
        startTime = now;
        voteLengthInSec = _voteLengthInSec;
        started = true;
    }
    
    constructor(string _name) public {
        owner = msg.sender;
        electionName = _name;
        passport = new Passport();
    }
    
    function addCandidate(uint _id) ownerOnly public {
        require((passport.count() - 1) > _id);
        candidates.push(Candidate(_id, 0));    
    } 
    
    function getCandidatesNum() public view returns(uint) {
        return candidates.length;
    }
    
    function authorize(address _person) ownerOnly public {
        require(passport.userAddress(_person) != 0);
        voters[_person].authorized = true;
    }
    
    function vote(uint _vote) timeGate public {
        require(!voters[msg.sender].voted);
        require(voters[msg.sender].authorized);
        
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = _vote;
        
        candidates[_vote].voteCount++;
        totalVotes++;
    }
    
    function getWinner() public view userOrOwner returns(uint) {
        uint winnerId = 0;
        for(uint i= 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > candidates[winnerId].voteCount) {
                winnerId = i;
            }
        }
        return winnerId;
    }
    
    function terminateVoting() ownerOnly public {
        selfdestruct(owner);
    }
}