pragma solidity >=0.4.21 <0.6.0;

import "./Betable.sol";
import "./CoinFlip.sol";

contract Casino is Ownable {
    Betable[] public games;

    event betCreated(Betable bet);
    event betClosed(Betable bet);
    event betClaimed(address winner, uint256 yield);

    function createFlipCoinBet() public payable {
        CoinFlip g = new CoinFlip(address(uint160(address(this))));
        games.push(g);

        emit betCreated(g);
    }

    function joinFlipCoinBet(uint256 index) public payable {
        CoinFlip g = CoinFlip(address(games[index]));
        g.bet();

        emit betClosed(g);
    }

    function claimFlipCoinWin(uint256 index) public payable {
        CoinFlip g = CoinFlip(address(games[index]));
        address winner = g.getWinner();
        uint256 yield = g.getYield();
        g.destructor();

        emit betClaimed(winner, yield);
    }

    function withdraw() public onlyOwner returns (uint256) {
        uint256 toTransfer = address(this).balance;
        msg.sender.transfer(toTransfer);
        assert(address(this).balance == 0);
        return toTransfer;
    }
}
