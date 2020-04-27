pragma solidity >= 0.5.0 < 0.6.0;

import "./ProvableAPI.sol";

contract usingRandomProvable is usingProvable {

    uint256 constant QUERY_EXECUTION_DELAY = 0;
    uint256 constant MAX_INT_FROM_BYTE = 256;
    uint256 constant NUM_RANDOM_BYTES_REQUESTED = 7;

    constructor() public {
        provable_setProof(proofType_Ledger);
    }

    function getRandomNumber(uint256 gas_for_callback) internal {
        provable_newRandomDSQuery(
            QUERY_EXECUTION_DELAY,
            NUM_RANDOM_BYTES_REQUESTED,
            gas_for_callback
        );
    }

    function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
        require(msg.sender == provable_cbAddress());
        assert(provable_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0);
        receiveRandomNumber(uint256(keccak256(abi.encodePacked(_result))));
    }

    function receiveRandomNumber(uint256 random) internal;

}
