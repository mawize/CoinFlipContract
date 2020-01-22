pragma solidity >=0.4.21 <0.6.0;

import "./Betable.sol";
import "./Player.sol";

contract CoinFlip is Betable{

    uint public balance;

    modifier costs(uint cost){
        require(msg.value >= cost);
        _;
    }
    event coinFlipped(bool result);
    event winner(address addr);

    function flipCoin(bool betPlayerOne) public  {
        bool result = block.timestamp % 2 == 0;
        if(result == betPlayerOne) {
            msg.sender.transfer(2 * msg.value);

            emit winner(msg.sender);
        }
        emit coinFlipped(result);
    }



}
