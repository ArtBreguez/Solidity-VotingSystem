pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;
// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {

    address public owner;

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() public{
        owner = msg.sender;
    }
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "NOT THE OWNER");
        _;
    }
    /**
     * @dev Transfers ownership of the contract to a new account (_newOwner).
     * Can only be called by the current owner.
     */
    function setNewOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "INVALID ADDRESS");
        owner = _newOwner;
    }
}
