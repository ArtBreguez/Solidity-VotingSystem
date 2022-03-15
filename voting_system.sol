pragma solidity 0.4.18;
//SPDX-License-Identifier: MIT

import "./users.sol";
import "./candidates.sol";

contract VotingSystem {
    
    struct UserInfo {
        string Name;
        uint Age;
        uint CPF;
        bool HasVoted;
        uint Index;
    }

    struct Candidates {
        string Name;
        uint Number;
        uint NumberOfVotes;
        uint Index;
    }
    uint[] private Users;
    uint[] private CurrentCandidates;
    
    mapping (uint => UserInfo) private UserData;
    mapping (uint => Candidates) private Candidate;

    event LogNewUser(uint indexed _CPF, uint Index, string Name, uint Age);
    event LogUpdateUser(uint indexed _CPF, uint Index, string Name, uint Age);
    event LogDeletedUser(uint indexed _CPF, uint Index);
    event LogNewCandidate(uint indexed _Number, string Name, uint Index);
    event LogDeletedCandidate(uint indexed _Number, uint Index);
    event LogCurrentCandidates(uint indexed _Number, string Name);
    
    function UserExist(uint _CPF) public constant returns(bool isUser) {
        if(Users.length == 0) return false;
        return (Users[UserData[_CPF].Index] == _CPF);
    }
    function CandidateExist(uint _Number) public constant returns(bool isCandidate) {
        if(CurrentCandidates.length == 0) return false;
        return (CurrentCandidates[Candidate[_Number].Index] == _Number);
    }
    function AddNewUser(string _Name, uint _Age, uint _CPF) public returns(uint Index){
            if(UserExist(_CPF)) throw;
            UserData[_CPF].Name = _Name;
            UserData[_CPF].Age = _Age;
            UserData[_CPF].CPF = _CPF;
            UserData[_CPF].HasVoted = false;
            LogNewUser(
                _CPF,
                UserData[_CPF].Index,
                _Name,
                _Age
            );
            UserData[_CPF].Index = Users.push(_CPF) -1;        
            return Users.length-1;
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

    function ViewUser(uint _CPF) public constant returns (string Name, uint Age, bool HasVoted) {
        if(!UserExist(_CPF)) throw;
        return (UserData[_CPF].Name, UserData[_CPF].Age, UserData[_CPF].HasVoted);
    }
    function ViewCandidate(uint _Number) public constant returns (string Name, uint Number) {
        if(!CandidateExist(_Number)) throw;
        return (Candidate[_Number].Name, Candidate[_Number].Number);
    }
    function GetUsersCount() public constant returns(uint count) {
        return Users.length;
    }
    function GetCandidatesList() public constant returns(string Number) { //problem
        uint tamanho = CurrentCandidates.length;
        for (uint i = 0; i<tamanho; i++) {
            return(CurrentCandidates[i].Name);
        }
    }
    
    function GetUserAtIndex(uint Index) public constant returns(uint CPF) {
        return Users[Index];
    }
    function ViewCandidateVotes(uint _Number) public constant returns (string Name, uint NumberOfVotes) {
        if(!CandidateExist(_Number)) throw;
        return (Candidate[_Number].Name, Candidate[_Number].NumberOfVotes);
    }
    function UserAgeUpdate(uint _CPF, uint _Age) public returns(bool success) {
        if(!UserExist(_CPF)) throw;
        UserData[_CPF].Age = _Age;
        LogUpdateUser(
                _CPF,
                UserData[_CPF].Index,
                UserData[_CPF].Name,
                _Age
            );
        return true;
    }
    function DeleteUser(uint _CPF) public returns (uint Index) {
        if(!UserExist(_CPF)) throw;
        uint rowToDelete = UserData[_CPF].Index; // armazena em rowToDelete o indice do registro que se deseja deletar
        uint keyToMove = Users[Users.length-1]; //Pega o ultimo registro da lista e salva em keyToMove
        Users[rowToDelete] = keyToMove; //Coloca o ultimo registro da lista no lugar do registro que se deseja apagar
        UserData[keyToMove].Index = rowToDelete; //atualiza o indice do registro que foi movido pro espaço do que foi deletado
        Users.length--; //Dropa a ultima coluna da lista
        LogDeletedUser(
            _CPF,
            rowToDelete
        );
        LogUpdateUser(
            keyToMove,
            rowToDelete,
            UserData[_CPF].Name,
            UserData[_CPF].Age
        );
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
        function Votation (uint _CPF, uint _Number) public returns (string Name, bool HasVoted) {
        if(UserData[_CPF].HasVoted == true) throw;
        if(!UserExist(_CPF)) throw; //por enquanto se o usuario não existir, apenas sair da função
        if(!CandidateExist(_Number)) throw;
        Candidate[_Number].NumberOfVotes++;
    }

}
