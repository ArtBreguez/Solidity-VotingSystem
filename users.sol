pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./ownable.sol";

contract InterfaceUsers {
    function viewUserStatus(uint _CPF) external view returns(bool HasVoted);
    function updateUserStatus(uint _CPF) external;
}

contract users is Ownable{

    struct Users {
        string Name;
        uint CPF;
        uint Age;
        bool HasVoted;
    }

    mapping(uint => Users) usuarios;

    Users[] CurrentUsers;

    event LogNewUser(uint indexed _CPF, string Name, uint Age);
    event LogUpdateUser(uint indexed _CPF, string Name, uint Age);
    event LogDeletedUser(uint indexed _CPF, string Name);

    function addUser(string calldata _Name, uint _CPF, uint _Age) external{
        require(_CPF != 0, "O CPF NÃO PODE SER ZERO!");
        require(usuarios[_CPF].CPF == 0, "O CPF JA ESTÁ CADASTRADO!");
        Users memory usuario = Users(_Name, _CPF, _Age, false);
        usuarios[_CPF] = usuario;
        emit LogNewUser(
            _CPF,
            _Name,
            _Age
        );
    }
    function getUser(uint _CPF) external view returns(string memory Name, uint Age, bool HasVoted) {
        require(usuarios[_CPF].CPF != 0);
        return(usuarios[_CPF].Name, usuarios[_CPF].Age, usuarios[_CPF].HasVoted);
    }
    function viewUserStatus(uint _CPF) external returns(bool HasVoted) {
        require(usuarios[_CPF].CPF != 0, "O USUARIO NÃO EXISTE!");
        return(usuarios[_CPF].HasVoted);
    }
    function updateUser(string calldata _Name, uint _CPF, uint _Age) external {
        require(_CPF != 0, "O CPF NÃO PODE SER ZERO!");
        require(usuarios[_CPF].CPF != 0, "O USUARIO NÃO EXISTE!");
        usuarios[_CPF].Name = _Name;
        usuarios[_CPF].Age = _Age;
        emit LogUpdateUser(
            _CPF,
            _Name,
            _Age
        );
    }
    function updateUserStatus(uint _CPF) external {
        require(usuarios[_CPF].CPF != 0, "O USUARIO NÃO EXISTE!");
        usuarios[_CPF].HasVoted = true;
    }
    function deleteUser(uint _CPF) external {
        require(usuarios[_CPF].CPF != 0, "O USUARIO NÃO EXISTE!");
        delete usuarios[_CPF];
        emit LogDeletedUser(
            _CPF,
            usuarios[_CPF].Name
        );
    }
}
