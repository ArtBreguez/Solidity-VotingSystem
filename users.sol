pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract users {

    struct Users {
        string Name;
        uint CPF;
        uint Age;
        bool HasVoted;
    }

    mapping(uint => Users) usuarios;

    function addUser(string calldata _Name, uint _CPF, uint _Age) external{
        Users memory usuario = Users(_Name, _CPF, _Age, false);
        usuarios[_CPF] = usuario;
    }
    function getUser(uint _CPF) external view returns(string memory Name, uint Age, bool HasVoted) {
        return(usuarios[_CPF].Name, usuarios[_CPF].Age, usuarios[_CPF].HasVoted);
    }
    function updateUser(string calldata _Name, uint _CPF, uint _Age) external {
        usuarios[_CPF].Name = _Name;
        usuarios[_CPF].Age = _Age;
    }
    function deleteUser(uint _CPF) external {
        delete usuarios[_CPF];
    }
}
