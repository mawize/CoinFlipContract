pragma solidity >=0.4.21 <0.6.0;

import "./Betable.sol";
import "./CoinFlip.sol";

contract Casino is Ownable {
    Betable[] public games;

    event betCreated(Betable bet);
    event betClosed(Betable bet);
    event betClaimed(address winner, uint256 yield);

    function createFlipCoinBet() public payable returns (Betable) {
        CoinFlip g = (new CoinFlip).value(msg.value)(
            address(uint160(address(this)))
        );
        g.setOwner(msg.sender);

        games.push(g);

        emit betCreated(g);
        return g;
    }

    function withdraw() public onlyOwner returns (uint256) {
        uint256 toTransfer = address(this).balance;
        msg.sender.transfer(toTransfer);
        assert(address(this).balance == 0);
        return toTransfer;
    }
}
