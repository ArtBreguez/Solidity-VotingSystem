pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

/// @title Interface Candidates
/// @author Arthur Gonçalves Breguez
/// @notice Create and Manipulate candidates data
/// @dev ABIEncoderV2 Do not use on production
import "./ownable.sol";

contract InterfaceCandidates {

        struct Candidates {
        uint Id;
        string Name;
        uint Number;
        uint Votes;
    }
    
    function getCandidate(uint _Number) external view returns(string memory Name);
    function getCandidateArray() public view returns(Candidates[] memory);
    function isCandidate(uint _Number) external view returns(bool isCandidate);
    function updateVotes(uint _Number) external;
}

/// @title CRUD Candidates
/// @author Arthur Gonçalves Breguez
/// @notice Create and Manipulate candidates data
/// @dev ABIEncoderV2 Do not use on production
contract candidates is Ownable {

    struct Candidates {
        uint Id;
        string Name;
        uint Number;
        uint Votes;
    }

    constructor(address _voteContract) public {
        voteContract = _voteContract;
    }

    /// @notice Make the function be called only by the "voting_system" contact
    modifier onlyVote() {
        require(msg.sender == voteContract, "BAD METHOD CALL");
        _;
    }

    mapping (uint => Candidates) candidates;
    Candidates[] currentCandidates;
    uint candidatesCount = 0;
    address voteContract;
    
    /// @notice Emit  logs when a candidate is created, updated and deleted
    event LogNewCandidate(uint indexed _Number, string Name, uint Id);
    event LogUpdateCandidate(uint indexed _Number, string Name, uint Id);
    event LogDeletedCandidate(uint indexed _Number, uint Id);

    /// @notice Function to create a new candidate and add to list
    /// @param _Name Candidate name
    /// @param _Number Candidate number
    function addCandidate(string calldata _Name, uint _Number) external onlyOwner{
        require(_Number != 0, "CANDIDATE NUMBER CANNOT BE ZERO");
        require(candidates[_Number].Number == 0, "CANDIDATE ALREADY REGISTERED");
        Candidates memory candidate = Candidates(candidatesCount, _Name, _Number, 0);
        candidates[_Number] = candidate;
        currentCandidates.push(candidates[_Number]);
        candidatesCount++;
        emit LogNewCandidate(
            _Number,
            _Name,
            candidates[_Number].Id
        );
    }
    /// @notice Function to view candidate Name
    /// @param _Number Candidate number
    /// @return Name Candidate name
    function getCandidate(uint _Number) external view returns(string memory Name) {
        require(candidates[_Number].Number != 0, "CANDIDATE DO NOT EXIST");
        return candidates[_Number].Name;
    }
    /// @notice Functon to verify if a number is from a candidate
    /// @param _Number Candidate number
    /// @return isCandidate True if a candidate has the input number
    function isCandidate(uint _Number) external view returns(bool isCandidate) { 
        require(candidates[_Number].Number != 0, "CANDIDATE DO NOT EXIST");
        return true;
    }
    /// @notice Update candidate name
    /// @param _Name New candidate name
    function updateCandidate(string calldata _Name, uint _Number) external onlyOwner{
        require(_Number != 0, "CANDIDATE NUMBER CANNOT BE ZERO");
        require(candidates[_Number].Number != 0, "CANDIDATE DO NOT EXIST");
        candidates[_Number].Name = _Name;
        emit LogUpdateCandidate(
            _Number,
            _Name,
            candidates[_Number].Id
        );
    }
    /// @notice Get the list o candidates
    /// @return Candidates[] Array with all candidates information
    /// @dev Experimental function from ABIEncoderV2
    function getCandidateArray() public view returns(Candidates[] memory) { 
        require(currentCandidates.length>=0, "THERE IS NO CANDIDATES IN THE LIST");
        Candidates[] memory candidates = new Candidates[](candidatesCount);
        for(uint i=0; i<candidatesCount; i++) {
            Candidates storage candidate = currentCandidates[i];
            candidates[i] = candidate;
        }
        return candidates;
    }
    /// @notice Function to update the number of votes of a candidate
    /// @param _Number Candidate number
    function updateVotes(uint _Number) external onlyVote{
        require(candidates[_Number].Number != 0, "CANDIDATE DO NOT EXIST");
        candidates[_Number].Votes++;
    }
    /// @notice Function to view the number of votes of a candidate
    /// @param _Number Candidate number
    /// @return Votes Candidate number of votes
     function viewCandidateVotesCached(uint _Number) external view returns(uint Votes) { //mais economico!
        require(candidates[_Number].Number != 0, "CANDIDATE DO NOT EXIST");
        uint Votes = candidates[_Number].Votes;
        return Votes;
    }   
    /// @notice Function to delete a candidate
    /// @param _Number Candidate number
    function deleteCandidate(uint _Number) external onlyOwner{
        require(candidates[_Number].Number != 0, "CANDIDATE DO NOT EXIST");
        uint candidateToDelete = candidates[_Number].Id;
        Candidates memory lastCandidate = currentCandidates[currentCandidates.length-1];
        currentCandidates[candidateToDelete] = lastCandidate;
        candidates[lastCandidate.Number].Id = candidateToDelete;
        currentCandidates.pop();
        delete candidates[_Number];
        candidatesCount--;
        emit LogDeletedCandidate(
            _Number,
            candidateToDelete
        );
    }
}
