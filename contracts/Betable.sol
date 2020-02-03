pragma solidity >=0.4.21 <0.6.0;

import "./Ownable.sol";

contract Betable is Ownable {
    address payable private house;
    uint256 private constant cut = 2; // percent

    address[] public participants;
    uint256 public count = 0;

    uint256 public balance = 0;
    uint256 public amount = 0;

    address public winner;

    modifier onlyWinner() {
        require(
            msg.sender == winner ||
                (winner == 0x0000000000000000000000000000000000000000 &&
                    msg.sender == owner),
            "Access denied. Only the Winner can claim this contract."
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

        participants.push(tx.origin);
        count++;

        balance += msg.value;
    }

    function claim() public payable onlyWinner {
        if (count == 1) {
            uint256 toTransfer = balance;
            msg.sender.transfer(toTransfer);
            balance = balance - toTransfer;
        } else {
            uint256 toWinner = getValue();
            //msg.sender.transfer(toWinner);
            balance = balance - toWinner;

            uint256 toHouse = balance;
            require(house.send(toHouse));
            balance = balance - toHouse;
        }
        assert(balance == 0);
    }

    function setWinner(uint256 index) internal {
        require(index < participants.length);
        winner = participants[index];
    }

    function getValue() public view returns (uint256) {
        return (balance * (100 - cut)) / 100;
    }

}
