pragma solidity >= 0.5.0 < 0.6.0;

import "./Ownable.sol";
import "./Stateable.sol";
//import "./usingRandomProvable.sol";
import "./usingBlocknumber.sol";

contract CoinFlip is Ownable, Stateable, usingBlocknumber {
    uint256 private constant cut = 2; // percent

    uint256 constant MAX_INT_FROM_BYTE = 256;
    uint256 constant NUM_RANDOM_BYTES_REQUESTED = 7;

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
    // 2 = 'flipped'
    // 3 = 'claimed'
    // 4 = 'done'
    // 5 = 'canceled'

    constructor(address casinoOwner, bool heads) public payable Stateable(0) {
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

        super.setState(1); // 1 = 'closed'

        // Flip the coin
        getRandomNumber();
    }

    function receiveRandomNumber(uint256 random) internal onlyState(1) {
        g.winner = (random % 2 == 0) ? g.starter : g.joiner;

        g.value = getValue();
        setOwner(g.winner);      
        super.setState(2); // 2 = 'flipped'
    }

    function claim() public payable onlyOwner() onlyState(2) {
        // 2 = 'flipped'
        uint256 toWinner = getValue();
        msg.sender.transfer(toWinner);
        g.balance = g.balance - toWinner;
        setOwner(g.house);
        super.setState(3); // 3 = 'claimed'
    }

    function cancel() public payable onlyOwner() onlyState(0) {
        // 0 = 'open'
        uint256 toTransfer = g.balance;
        msg.sender.transfer(toTransfer);
        g.balance = g.balance - toTransfer;
        setOwner(g.house);
        assert(g.balance == 0);
        super.setState(5); // 5 = 'canceled'
    }

    function collect() public payable onlyOwner() onlyState(3) {
        // 3 = 'claimed'
        uint256 toTransfer = g.balance;
        msg.sender.transfer(toTransfer);
        g.balance = g.balance - toTransfer;
        assert(g.balance == 0);
        super.setState(4); // 4 = 'done'
    }

    function getValue() private view returns (uint256) {
        return ((2*g.amount) * (100 - cut)) / 100;
    }
}
