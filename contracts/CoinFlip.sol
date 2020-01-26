pragma solidity >=0.4.21 <0.6.0;

import "./Betable.sol";

contract CoinFlip is Betable {
    constructor(address payable casino) public payable Betable(casino) {}

    function bet() public payable {
        super.bet();

        if (count == 2) {
            setWinner(block.timestamp % 2);
        }
    }
}
