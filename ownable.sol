pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract Ownable {

    address public owner;

    constructor() public{
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "NÃO É O DONO DO CONTRATO!");
        _;
    }
    function setNewOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "ENDEREÇO INVALIDO!");
        owner = _newOwner;
    }
}
