pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract candidates {

    struct Candidates {
        uint Id;
        string Name;
        uint Number;
        uint Votes;
    }
    mapping (uint => Candidates) candidatos;
    Candidates[] currentCandidates;
    uint candidatesCount = 0;

    function addCandidate1(string memory _Name, uint _Number) public {
        Candidates memory candidate = Candidates(candidatesCount, _Name, _Number, 0);
        candidatos[_Number] = candidate;
        currentCandidates.push(candidatos[_Number]);
        candidatesCount++;
    }
    function getCandidate(uint _Number) external view returns(string memory Name) {
        return candidatos[_Number].Name;
    }
    function updateCandidate(string calldata _Name, uint _Number) external {
        candidatos[_Number].Name = _Name;
        candidatos[_Number].Number = _Number;
    }
    function getCandidateArray() public view returns(Candidates[] memory) {
        Candidates[] memory candidates = new Candidates[](candidatesCount);
        for(uint i=0; i<candidatesCount; i++) {
            Candidates storage candidate = currentCandidates[i];
            candidates[i] = candidate;
        }
        return candidates;
    }
    function deleteCandidate(uint _Number) external {
        delete candidatos[_Number];
        delete currentCandidates[candidatos[_Number].Id];
        candidatesCount--;
    }
    function updateVotes(uint _Number) external {
        candidatos[_Number].Votes++;
    }
    function viewCandidateVotes(uint _Number) external view returns(uint Votes) {
        return(candidatos[_Number].Votes);
    }
}
