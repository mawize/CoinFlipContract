pragma solidity >=0.4.21 <0.6.0;

import "./Betable.sol";
import "./Player.sol";
import "./Destructable.sol";

contract Betable is Destructable {

    struct Bet {
        Player player;
        uint amount;
    }

    Bet[] private bets;
    uint balance = 0;

    constructor(Player player) public payable {
        paricipate(player);
    }

    function paricipate(Player player) public payable {
        // check if bets exists and update/add amount
        Bet memory bet;
        bet.player = player;
        bet.amount = msg.value;

        bets.push(bet);
        balance += bet.amount;
    }

    function destructor(Player winner) internal {
       uint toWinner = (balance * 98 ) / 100;
       uint toHouse = balance - toWinner;
       balance = 0;
       winner.addr.transfer(toWinner);
       msg.sender.transfer(toHouse);
    }

}