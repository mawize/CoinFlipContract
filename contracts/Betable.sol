pragma solidity >=0.4.21 <0.6.0;

import "./Ownable.sol";

contract Betable is Ownable {
    address payable private house;
    uint256 private constant cut = 2; // percent

    address[] internal participants;
    uint256 public count = 0;

    uint256 private balance = 0;
    uint256 public amount = 0;

    address private winner;

    modifier onlyWinner() {
        require(
            msg.sender == winner,
            "Access denied. Only the Winner can destroy this contract."
        );
        _;
    }

    constructor(address payable casino) public payable {
        house = casino;
        amount = msg.value;
        bet();
    }

    function bet() public payable {
        require(
            (balance == 0 && msg.value > 1 wei) || msg.value >= amount,
            "Not enough value."
        );

        participants.push(msg.sender);
        count++;

        balance += msg.value;
    }

    function destructor() public payable onlyWinner {
        uint256 toWinner = amount + getYield();
        uint256 toHouse = balance - toWinner;

        assert(balance == toWinner + toHouse);

        msg.sender.transfer(toWinner);
        balance = balance - toWinner;

        house.transfer(toHouse);
        balance = balance - toHouse;

        assert(balance == 0);

        selfdestruct(msg.sender);
    }

    function setWinner(uint256 index) internal {
        winner = participants[index];
    }

    function getWinner() public view returns (address) {
        return winner;
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function getYield() public view returns (uint256) {
        return (amount * (100 - cut)) / 100;
    }

    function getParticipants() public view returns (uint256) {
        return count;
    }

}
