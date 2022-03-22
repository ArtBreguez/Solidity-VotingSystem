pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

/// @title Users interface for blockchain voting system
/// @author Arthur Gonçalves Breguez
/// @notice Use this contract as an interface for "users.sol"
/// @dev ABIEncoderv2 experimental version, do not use this on production
import "./ownable.sol";

contract InterfaceUsers {
    function viewUserStatus(uint _CPF) external view returns(bool HasVoted);
    function updateUserStatus(uint _CPF) external;
}

/// @title Users system simulator for blockchain voting
/// @author Arthur Gonçalves Breguez
/// @notice Use this contract with "candidates.sol", "voting_system.sol" and "ownable.sol" to simulate a voting system on blockchain
/// @dev ABIEncoderv2 experimental version, do not use this on production
contract users is Ownable{

    struct Users {
        string Name;
        uint CPF;
        uint Age;
        bool HasVoted;
    }

    mapping(uint => Users) usuarios;

    Users[] CurrentUsers;

    /// @notice Emit a log when a user is created, updated or deleted
    event LogNewUser(uint indexed _CPF, string Name, uint Age);
    event LogUpdateUser(uint indexed _CPF, string Name, uint Age);
    event LogDeletedUser(uint indexed _CPF, string Name);

    /// @notice function to set the conctract address of "candidates.sol"
    /// @param _address Candidates contract address
    /// @return true Confirmation that the address is set
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
    /// @notice Get registered user information
    /// @param _CPF User unique identifier
    /// @return Name User full name
    /// @return Age User age
    /// @return HasVoted If user has already voted or not
    function getUser(uint _CPF) external view returns(string memory Name, uint Age, bool HasVoted) {
        require(usuarios[_CPF].CPF != 0);
        return(usuarios[_CPF].Name, usuarios[_CPF].Age, usuarios[_CPF].HasVoted);
    }
    /// @notice See if the user has already voted
    /// @param _CPF User unique identifier
    /// @return HasVoted If user has already voted or not
    function viewUserStatus(uint _CPF) external returns(bool HasVoted) {
        require(usuarios[_CPF].CPF != 0, "O USUARIO NÃO EXISTE!");
        return(usuarios[_CPF].HasVoted);
    }
    /// @notice Update user name or age
    /// @param _Name User new name
    /// @param _CPF User current CPF
    /// @param _Age User new age
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
    /// @notice Update user vote status
    /// @param _CPF User unique identifier
    function updateUserStatus(uint _CPF) external {
        require(usuarios[_CPF].CPF != 0, "O USUARIO NÃO EXISTE!");
        usuarios[_CPF].HasVoted = true;
    }
    /// @notice Delete user from contract
    /// @param _CPF User unique identifier
    function deleteUser(uint _CPF) external {
        require(usuarios[_CPF].CPF != 0, "O USUARIO NÃO EXISTE!");
        delete usuarios[_CPF];
        emit LogDeletedUser(
            _CPF,
            usuarios[_CPF].Name
        );
    }
}
