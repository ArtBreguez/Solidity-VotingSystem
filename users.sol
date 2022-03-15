pragma solidity 0.4.18;
//SPDX-License-Identifier: MIT
contract UserSystem {

    struct UserInfo {
        string Name;
        uint Age;
        uint CPF;
        bool HasVoted;
        uint Index;
    }

    uint[] private Users;
   
    
    mapping (uint => UserInfo) private UserData;

    event LogNewUser(uint indexed _CPF, uint Index, string Name, uint Age);
    event LogUpdateUser(uint indexed _CPF, uint Index, string Name, uint Age);
    event LogDeletedUser(uint indexed _CPF, uint Index);
    
    function UserExist(uint _CPF) public constant returns(bool isUser) {
        if(Users.length == 0) return false;
        return (Users[UserData[_CPF].Index] == _CPF);
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

    function ViewUser(uint _CPF) public constant returns (string Name, uint Age, bool HasVoted) {
        if(!UserExist(_CPF)) throw;
        return (UserData[_CPF].Name, UserData[_CPF].Age, UserData[_CPF].HasVoted);
    }
    function GetUsersCount() public constant returns(uint count) {
        return Users.length;
    }
    function GetUserAtIndex(uint Index) public constant returns(uint CPF) {
        return Users[Index];
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
}
