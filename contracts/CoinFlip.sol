pragma solidity >=0.4.21 <0.6.0;

import "./Ownable.sol";
import "./Stateable.sol";


contract CoinFlip is Ownable, Stateable {
    address private house;
    address private starter;
    address private joiner;

    uint256 private constant cut = 2; // percent

    uint256 public balance = 0;
    uint256 public amount = 0;

    // 0 = 'open'
    // 1 = 'closed'
    // 2 = 'claimed'
    // 3 = 'done'

    event CoinFlipped(address winner, uint256 yield);

    constructor(address casinoOwner) public payable Ownable() Stateable(0) {
        // 0 = 'open'
        require(msg.value > 1 wei, "Not enough value.");

        house = casinoOwner;
        
        starter = tx.origin;
        amount = msg.value;
        balance += msg.value;
        setOwner(starter);

        assert(amount == balance);
    }

    function join() public payable onlyState(0) {
        // 0 = 'open'
        require(msg.value >= amount, "Not enough value.");
        joiner = tx.origin;
        balance += msg.value;

        // Flip the coin
        address winner = (block.timestamp % 2 == 0) ? starter : joiner;
        setOwner(winner);
        emit CoinFlipped(winner, getValue());

        super.setState(1); // 1 = 'closed'
    }

    function claim() public payable onlyOwner() onlyState(1) {
        // 1 = 'closed'
        uint256 toWinner = getValue();
        msg.sender.transfer(toWinner);
        balance = balance - toWinner;
        setOwner(house);
        super.setState(2); // 2 = 'claimed'
    }

    function cancel() public payable onlyOwner() onlyState(0) {
        // 0 = 'open'
        uint256 toTransfer = balance;
        msg.sender.transfer(toTransfer);
        balance = balance - toTransfer;
        setOwner(house);
        assert(balance == 0);
        super.setState(3); // 3 = 'done'
    }

    function collect() public payable onlyOwner() onlyState(2) {
        // 2 = 'claimed'
        uint256 toTransfer = balance;
        msg.sender.transfer(toTransfer);
        balance = balance - toTransfer;
        assert(balance == 0);
        super.setState(3); // 3 = 'done'
    }

    function getValue() private view returns (uint256) {
        return (balance * (100 - cut)) / 100;
    }
}
