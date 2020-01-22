pragma solidity >=0.4.21 <0.6.0;

contract Ownable{
    address public owner;

    modifier onlyOwner(){
        require(msg.sender == owner, 'Access denied.');
        _; //Continue execution
    }

    constructor() public{
        owner = msg.sender;
    }
}