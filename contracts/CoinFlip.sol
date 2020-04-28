pragma solidity >= 0.5.0 < 0.6.0;

import "./Ownable.sol";
import "./Stateable.sol";
import "./usingRandomProvable.sol";

contract CoinFlip is Ownable, Stateable, usingRandomProvable {
    uint256 constant ORACLE_CALLBACK_GAS = 100000; // wei for oracle callback
    uint256 private constant CUT = 2; // percent

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
        require(msg.value > ORACLE_CALLBACK_GAS, "Not enough value.");
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
        assert((2*g.amount) <= g.balance);
        g.balance -= ORACLE_CALLBACK_GAS;
        g.value = getValue();
        setOwner(g.house); // while spinning
        super.setState(1); // 1 = 'closed'
        getRandomNumber(ORACLE_CALLBACK_GAS);
    }

    function receiveRandomNumber(uint256 random) internal onlyState(1) {
        g.winner = ((random % 2) == 0) ? g.starter : g.joiner;
        setOwner(g.winner);
        super.setState(2); // 2 = 'flipped'
    }

    function claim() public onlyOwner() onlyState(2) {
        // 2 = 'flipped'
        assert(g.balance > g.value);
        g.balance = g.balance - g.value;
        setOwner(g.house);
        super.setState(3); // 3 = 'claimed'
        msg.sender.transfer(g.value);
    }

    function cancel() public onlyOwner() onlyState(0) {
        // 0 = 'open'
        super.setState(5); // 5 = 'canceled'
        selfdestruct(msg.sender);
    }

    function collect() public onlyOwner() onlyState(3) {
        // 3 = 'claimed'        
        super.setState(4); // 4 = 'done'
        selfdestruct(msg.sender);
    }

    function getValue() private view returns (uint256) {
        return (((2*g.amount) - ORACLE_CALLBACK_GAS) * (100 - CUT)) / 100;
    }
}
