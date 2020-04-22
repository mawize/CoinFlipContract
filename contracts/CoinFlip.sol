pragma solidity >=0.4.21 <0.6.0;

import "./Ownable.sol";
import "./Stateable.sol";


contract CoinFlip is Ownable, Stateable {
    uint256 private constant cut = 2; // percent

    struct Game {
        address house;
        address starter;
        address joiner;
        address winner;
        uint256 value;
        uint256 balance;
        uint256 amount;
        bool heads;
    }

    Game public g;
    // States
    // 0 = 'open'    
    // 1 = 'closed'
    // 2 = 'claimed'
    // 3 = 'done'
    // 4 = 'canceled'

    constructor(address casinoOwner, bool heads) public payable Ownable() Stateable(0) {
        // 0 = 'open'
        require(msg.value > 1 wei, "Not enough value.");

        g.house = casinoOwner;

        g.heads = heads;

        g.starter = tx.origin;
        g.amount = msg.value;
        g.balance += msg.value;
        setOwner(g.starter);

        assert(g.amount == g.balance);
    }

    function join() public payable onlyState(0) {
        // 0 = 'open'
        require(msg.value >= g.amount, "Not enough value.");
        g.joiner = tx.origin;
        g.balance += msg.value;

        // Flip the coin
        g.winner = (block.timestamp % 2 == 0) ? g.starter : g.joiner;
        g.value = getValue();
        setOwner(g.winner);

        super.setState(1); // 1 = 'closed'
    }

    function claim() public payable onlyOwner() onlyState(1) {
        // 1 = 'closed'
        uint256 toWinner = getValue();
        msg.sender.transfer(toWinner);
        g.balance = g.balance - toWinner;
        setOwner(g.house);
        super.setState(2); // 2 = 'claimed'
    }

    function cancel() public payable onlyOwner() onlyState(0) {
        // 0 = 'open'
        uint256 toTransfer = g.balance;
        msg.sender.transfer(toTransfer);
        g.balance = g.balance - toTransfer;
        setOwner(g.house);
        assert(g.balance == 0);
        super.setState(4); // 3 = 'done'
    }

    function collect() public payable onlyOwner() onlyState(2) {
        // 2 = 'claimed'
        uint256 toTransfer = g.balance;
        msg.sender.transfer(toTransfer);
        g.balance = g.balance - toTransfer;
        assert(g.balance == 0);
        super.setState(3); // 3 = 'done'
    }

    function getValue() private view returns (uint256) {
        return ((2*g.amount) * (100 - cut)) / 100;
    }
}
