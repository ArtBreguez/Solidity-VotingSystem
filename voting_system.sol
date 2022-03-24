pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

/// @title Blockchain voting system simulator
/// @author Arthur Gonçalves Breguez
/// @notice Use this contract with "users.sol", "candidates.sol" and "ownable.sol" to simulate a voting system on blockchain
/// @dev ABIEncoderV2 Do not use on production
import "./users.sol";
import "./candidates.sol";
import "./ownable.sol";

contract Voting is Ownable {

    address candidates_contract;
    address users_contract;

    /// @notice Emit a log when a new vote is made
    event LogNewVote(uint indexed _CPF, bool HasVoted);

    /// @notice Function to set the conctract address of "candidates.sol"
    /// @param _address Candidates contract address
    function setAddresToCandidadatesContract(address _address) external onlyOwner{
        candidates_contract = _address;
        //return true;
    }
    /// @notice Function to set the conctract address of "users.sol"
    /// @param _address Users contract address
    function setAddresToUsersContract(address _address) external onlyOwner{
        users_contract = _address;
    }
    /// @notice Function View the candidate Name using the candidate Number
    /// @param _Number Candidate number
    /// @return Name Candidate name
    function viewCandidate(uint _Number) external view returns (string memory Name) {
        InterfaceCandidates view_candidate = InterfaceCandidates(candidates_contract);
        return view_candidate.getCandidate(_Number);
    }
    /// @notice Function to perform the vote, one vote for each person
    /// @param _CPF Unique cpf of the person who votes,
    /// @param _CandidateNumber Is the candidate Number of the election 
    function vote(uint _CPF, uint _CandidateNumber) external{
        InterfaceCandidates candidate = InterfaceCandidates(candidates_contract);
        InterfaceUsers user = InterfaceUsers(users_contract);
        require(user.viewUserStatus(_CPF) == false, "USER ALREADY VOTED");
        require(candidate.isCandidate(_CandidateNumber) == true, "CANDIDATE NOT FOUND");
        candidate.updateVotes(_CandidateNumber);
        user.updateUserStatus(_CPF);
        emit LogNewVote(
            _CPF,
            true
        );
    }
}
