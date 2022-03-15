pragma solidity 0.4.18;
//SPDX-License-Identifier: MIT

contract CandidateSystem {

    struct Candidates {
        string Name;
        uint Number;
        uint NumberOfVotes;
        uint Index;
    }
    uint[] private CurrentCandidates;

    mapping (uint => Candidates) public Candidate;

    event LogNewCandidate(uint indexed _Number, string Name, uint Index);
    event LogDeletedCandidate(uint indexed _Number, uint Index);

    function CandidateExist(uint _Number) public constant returns(bool isCandidate) {
        if(CurrentCandidates.length == 0) return false;
        return (CurrentCandidates[Candidate[_Number].Index] == _Number);
    }
    function AddNewCandidate(string _Name, uint _Number) public returns(uint Index){
            if(CandidateExist(_Number)) throw;
            Candidate[_Number].Number = _Number;
            Candidate[_Number].Name = _Name;            
            LogNewCandidate(
                _Number,
                _Name,
                Candidate[_Number].Index
            );
            Candidate[_Number].Index = CurrentCandidates.push(_Number) -1;        
            return CurrentCandidates.length-1;
    }
    function ViewCandidate(uint _Number) public constant returns (string Name, uint Number) {
        if(!CandidateExist(_Number)) throw;
        return (Candidate[_Number].Name, Candidate[_Number].Number);
    }
    function ViewCandidateVotes(uint _Number) public constant returns (string Name, uint NumberOfVotes) {
        if(!CandidateExist(_Number)) throw;
        return (Candidate[_Number].Name, Candidate[_Number].NumberOfVotes);
    }
    function GetCandidatesCount() public constant returns(uint count) {
        return CurrentCandidates.length;
    }
    function DeleteCandidate(uint _Number) public returns (uint Index) {
        if(!CandidateExist(_Number)) throw;
        uint rowToDelete = Candidate[_Number].Index; // armazena em rowToDelete o indice do registro que se deseja deletar
        uint keyToMove = CurrentCandidates[CurrentCandidates.length-1]; //Pega o ultimo registro da lista e salva em keyToMove
        CurrentCandidates[rowToDelete] = keyToMove; //Coloca o ultimo registro da lista no lugar do registro que se deseja apagar
        Candidate[keyToMove].Index = rowToDelete; //atualiza o indice do registro que foi movido pro espaço do que foi deletado
        CurrentCandidates.length--; //Dropa a ultima coluna da lista
        LogDeletedCandidate(
            _Number,
            rowToDelete
        );
    }
}
