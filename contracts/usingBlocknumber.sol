pragma solidity >= 0.5.0 < 0.6.0;

contract usingBlocknumber {

    function getRandomNumber() internal {
        receiveRandomNumber(block.timestamp);
    }

    function receiveRandomNumber(uint256 random) internal;

}
