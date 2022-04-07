pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

/// @title Interface Users
/// @author Arthur Gonçalves Breguez
/// @notice Create and Manipulate users data
/// @dev ABIEncoderV2 Do not use on production
import "./ownable.sol";

contract InterfaceUsers {
    function viewUserStatus(uint _CPF) external view returns(bool HasVoted);
    function updateUserStatus(uint _CPF) external;
}

/// @title CRUD Users
/// @author Arthur Gonçalves Breguez
/// @notice Create and Manipulate users data
/// @dev ABIEncoderV2 Do not use on production
contract users is Ownable{

    struct Users {
        string Name;
        uint CPF;
        uint Age;
        bool HasVoted;
    }

    constructor(address _voteContract) public {
        voteContract = _voteContract;
    }

    /// @notice Make the function be called only by the "voting_system" contact
    modifier onlyVote() {
        require(msg.sender == voteContract, "BAD METHOD CALL");
        _;
    }

    mapping(uint => Users) users;
    
    address voteContract;

    /// @notice Emit  logs when an user is created, updated and deleted
    event LogNewUser(uint indexed _CPF, string Name, uint Age);
    event LogUpdateUser(uint indexed _CPF, string Name, uint Age);
    event LogDeletedUser(uint indexed _CPF, string Name);

    /// @notice Function to create a new user
    /// @param _Name User name
    /// @param _CPF User unique number
    /// @param _Age User age
    function addUser(string calldata _Name, uint _CPF, uint _Age) external{
        require(_CPF != 0, "CPF CANNOT BE ZERO");
        require(users[_CPF].CPF == 0, "CPF ALREADY REGISTERED");
        Users memory usuario = Users(_Name, _CPF, _Age, false);
        users[_CPF] = usuario;
        emit LogNewUser(
            _CPF,
            _Name,
            _Age
        );
    }

    /// @notice Function to view user information
    /// @param _CPF User CPF
    /// @return Name User name
    /// @return Age User age
    /// @return HasVoted If user has already voted
    function getUser(uint _CPF) external view returns(string memory Name, uint Age, bool HasVoted) {
        require(users[_CPF].CPF != 0);
        return(users[_CPF].Name, users[_CPF].Age, users[_CPF].HasVoted);
    }
    /// @notice Function to view if an user has already voted
    /// @param _CPF User CPF
    /// @return HasVoted If user has already voted
    function viewUserStatus(uint _CPF) external view returns(bool HasVoted) {
        require(users[_CPF].CPF != 0, "USER DO NOT EXIST");
        return(users[_CPF].HasVoted);
    }
    /// @notice Function to update user name/age
    /// @param _Name User new name
    /// @param _CPF User CPF
    /// @param _Age User new age
    function updateUser(string calldata _Name, uint _CPF, uint _Age) external {
        require(_CPF != 0, "CPF CANNOT BE ZERO");
        require(users[_CPF].CPF != 0, "USER DO NOT EXIST");
        users[_CPF].Name = _Name;
        users[_CPF].Age = _Age;
        emit LogUpdateUser(
            _CPF,
            _Name,
            _Age
        );
    }
    /// @notice Function to update user voting status
    /// @param _CPF User CPF
    function updateUserStatus(uint _CPF) external onlyVote{
        require(users[_CPF].CPF != 0, "USER DO NOT EXIST");
        users[_CPF].HasVoted = true;
    }
    /// @notice Function to delete an user
    /// @param _CPF User CPF
    function deleteUser(uint _CPF) external {
        require(users[_CPF].CPF != 0, "USER DO NOT EXIST");
        delete users[_CPF];
        emit LogDeletedUser(
            _CPF,
            users[_CPF].Name
        );
    }
}
