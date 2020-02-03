pragma solidity >=0.4.21 <0.6.0;

import "./Betable.sol";

contract CoinFlip is Betable {
    constructor(address payable casino) public payable Betable(casino) {}

    event coinFlipped(address winner, uint256 yield);

    function bet() public payable {
        require(count <= 2, "rien ne va plus!");
        super.bet();

        if (count == 2) {
            setWinner(block.timestamp % 2);
            emit coinFlipped(winner, getValue());
        }
    }

}
