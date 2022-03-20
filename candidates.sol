pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

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

    modifier onlyVote() {
        require(msg.sender == voteContract, "FUNÇÃO CHAMADA DE MANEIRA ERRADA!");
        _;
    }

    mapping (uint => Candidates) candidatos;
    Candidates[] currentCandidates;
    uint candidatesCount = 0;
    address voteContract;
    
    event LogNewCandidate(uint indexed _Number, string Name, uint Id);
    event LogUpdateCandidate(uint indexed _Number, string Name, uint Id);
    event LogDeletedCandidate(uint indexed _Number, uint Id);

    function addCandidate1(string calldata _Name, uint _Number) external onlyOwner{
        require(_Number != 0, "O NUMERO DO CANDIDATO NÃO PODE SER ZERO!");
        require(candidatos[_Number].Number == 0, "O CANDIDATO JA ESTÁ CADASTRADO!");
        Candidates memory candidate = Candidates(candidatesCount, _Name, _Number, 0);
        candidatos[_Number] = candidate;
        currentCandidates.push(candidatos[_Number]);
        candidatesCount++;
        emit LogNewCandidate(
            _Number,
            _Name,
            candidatos[_Number].Id
        );
    }
    function getCandidate(uint _Number) external view returns(string memory Name) {
        require(candidatos[_Number].Number != 0, "O CANDIDATO NÃO EXISTE!");
        return candidatos[_Number].Name;
    }
    function isCandidate(uint _Number) external view returns(bool isCandidate) { 
        require(candidatos[_Number].Number != 0, "O CANDIDATO NÃO EXISTE!");
        return true;
    }
    function updateCandidate(string calldata _Name, uint _Number) external onlyOwner{
        require(_Number != 0, "O NÚMERO DO CANDIDATO NÃO PODE SER ZERO!");
        require(candidatos[_Number].Number != 0, "O CANDIDATO NÃO EXISTE!");
        candidatos[_Number].Name = _Name;
        candidatos[_Number].Number = _Number;
        emit LogUpdateCandidate(
            _Number,
            _Name,
            candidatos[_Number].Id
        );
    }
    function getCandidateArray() public view returns(Candidates[] memory) { 
        require(currentCandidates.length>=0, "NÃO HÁ CANDIDATOS NA LISTA!");
        Candidates[] memory candidates = new Candidates[](candidatesCount);
        for(uint i=0; i<candidatesCount; i++) {
            Candidates storage candidate = currentCandidates[i];
            candidates[i] = candidate;
        }
        return candidates;
    }
    function updateVotes(uint _Number) external onlyVote{
        require(candidatos[_Number].Number != 0, "O CANDIDATO NÃO EXISTE!");
        candidatos[_Number].Votes++;
    }
    function viewCandidateVotes(uint _Number) external view returns(uint Votes) {
        require(candidatos[_Number].Number != 0, "O CANDIDATO NÃO EXISTE!");
        return(candidatos[_Number].Votes);
    }
    function deleteCandidate(uint _Number) external onlyOwner{
        require(candidatos[_Number].Number != 0, "O CANDIDATO NÃO EXISTE");
        uint candidateToDelete = candidatos[_Number].Id;
        Candidates memory lastCandidate = currentCandidates[currentCandidates.length-1];
        currentCandidates[candidateToDelete] = lastCandidate;
        candidatos[lastCandidate.Number].Id = candidateToDelete;
        currentCandidates.pop();
        delete candidatos[_Number];
        candidatesCount--;
        emit LogDeletedCandidate(
            _Number,
            candidateToDelete
        );
    }
}
