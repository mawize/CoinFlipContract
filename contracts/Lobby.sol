pragma solidity >=0.4.21 <0.6.0;

import "./Betable.sol";
import "./Player.sol";

contract Lobby is Ownable {

    event playerEntered(Player player);
    event playerLeft(string name, uint balance);

    event winner(Betable game, Player player);
    event message(Player player, string message);
    event betCreated(Betable bet);
    event betClosed(Betable bet);

    mapping (address => Player) private people;
    address[] private creators;

    function enter(string memory name) public {
        //This creates a person
        Player newPerson = new Player(name);

        address creator = msg.sender;
        people[creator] = newPerson;

        creators.push(msg.sender);

        emit playerEntered(newPerson);
    }

    function leave() public {
        string memory name = people[msg.sender].name;
        uint balance = people[msg.sender].balance;
        people[msg.sender].balance = 0;
        msg.sender.transfer(balance);

        delete people[msg.sender];
        emit playerLeft(name, balance);
    }

    function getPlayer() public view returns(Player){
        address creator = msg.sender;
        return people[creator];
    }

    function getCreator(uint index) public view onlyOwner returns(address){
        return creators[index];
    }

    function withdrawAll() public onlyOwner returns(uint) {
    }



}