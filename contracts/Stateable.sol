pragma solidity >=0.4.21 <0.6.0;


contract Stateable {
    uint256 private state;

    event StateChanged(uint256 newState);

    modifier onlyState(uint256 expected) {
        require(expected == state, "Access denied. Wrong state.");
        _; //Continue execution
    }

    constructor(uint256 initial) public {
        setState(initial);
    }

    function getState() public view returns (uint256) {
        return state;
    }

    function setState(uint256 newState) internal {
        state = newState;
        emit StateChanged(state);
    }
}
