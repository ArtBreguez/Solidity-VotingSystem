# Solidity-VotingSystem

### BLOCKCHAIN BASED VOTING SYSTEM ###

### Description ###

This project simulate a voting system with users and candidates build on blockchain to avoid electoral fraud. Designed in solidity, a blockchain programming
language, we can track down the transactions to make sure that the votes from users to candidates are correct and no fraud is committed.

This project was built using solidity ^0.5.0 with experimental ABIEncoderV2 and Remix IDE.

### RUN THE PROJECT ###

This project is only for simulation purpose, do not use on production!

To run this project you can use Remix IDE to deploy the contracts

1° Deploy the ownable contract (or import from OpenZeppelin).

2° Deploy the voting_system contract.

3° Deploy the users and candidates contract, you will need the address from the voting_system contract to deploy the others.

4° Set the address of the users and candidates contract to the voting_system contract, this way the voting system contract can interact with the users and candidates functions.

5° Add some candidates and some users in their respective contracts and you can make the votation on the voting_system contract.

### CREDITS ###

Made by: Arthur Gonçalves Breguez.
