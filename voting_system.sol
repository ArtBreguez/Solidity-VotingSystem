pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./users_new.sol";
import "./new_candidates.sol";

contract Voting {

    address candidates_contract;
    address users_contract;
    
    event LogNewVote(uint indexed _CPF, bool HasVoted);

    function setAddresToCandidadatesContract(address _address) external {
        candidates_contract = _address;
    }
    function setAddresToUsersContract(address _address) external {
        users_contract = _address;
    }
    function viewCandidate(uint _Number) external view returns (string memory Name) {
        InterfaceCandidates view_candidate = InterfaceCandidates(candidates_contract);
        return view_candidate.getCandidate(_Number);
    }
    function vote(uint _CPF, uint _CandidateNumber) external{
        InterfaceCandidates candidate = InterfaceCandidates(candidates_contract);
        InterfaceUsers user = InterfaceUsers(users_contract);
        require(user.viewUserStatus(_CPF) == false, "CPF NÃO ENCONTRADO!");
        require(candidate.isCandidate(_CandidateNumber) == true, "CANDIDATO NÃO ENCONTRADO!");
        candidate.updateVotes(_CandidateNumber);
        user.updateUserStatus(_CPF);
        emit LogNewVote(
            _CPF,
            true
        );
    }
}
