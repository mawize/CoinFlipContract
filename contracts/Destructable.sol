pragma solidity >=0.4.21 <0.6.0;

contract Destructable {

    function destruct() private {
        selfdestruct(msg.sender);
    }
}