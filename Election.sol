pragma solidity >=0.4.24;
import "./Passport.sol";
import "./Owned.sol";

contract Election is Owned{

    struct Candidate {
        uint id;
        uint voteCount;
    }
    
    struct Voter {
        bool authorized;
        bool voted;
    }
    
    string public electionName;
    Candidate[] public candidates;
    
    mapping(id => Voter) public voters;
    Passport public passport;
    
    // function startVote() public {
    // }
    
    // function endVote() public {
    // }
    
    constructor(string _name) public {
        owner = msg.sender;
        electionName = _name;
        passport = new Passport();
    }
    
    function createUser(string _name, string _surname, uint _age) public ownerOnly {
        passport.createUser(_name, _surname, _age);
    }
    
    
    function addCandidate(uint _id) ownerOnly public {
        if (passport.count() > _id) {
            candidates.push(Candidate(_id, 0));    
        }
    } 
    
    function getCandidatesNum() public view returns(uint) {
        return candidates.length;
    }
    
    function authorize(uint _person) ownerOnly public {
        if (passport.count() > _id) {
            voters[_person].authorized = true;
        }
    }
    
    function vote(uint _voterId) public {
        require(!voters[_voterId].voted);
        require(!voters[_voterId].authorized);
    }
    
    // function terminateVoting() ownerOnly public {
        
    // }
}