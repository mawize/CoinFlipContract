pragma solidity >=0.4.21 <0.6.0;

import "./Ownable.sol";
import "./CoinFlip.sol";


contract Casino is Ownable {

    CoinFlip[] public games;
    uint256 public count = 0;

    event GameCreated(address game);

    constructor() public Ownable() {}

    function createCoinFlip(bool heads) public payable {
        games.push((new CoinFlip).value(msg.value)(getOwner(), heads));
        count++;
        emit GameCreated(address(games[count - 1]));
    }
}
