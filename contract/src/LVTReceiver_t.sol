pragma solidity ^0.4.11;

import "./LVTReceiver.sol";

contract TestLVTReceiver is LVTReceiver {
    event TestLVTFallBack(address indexed _from, uint _value, bytes _data);
    function tokenFallback(address _from, uint _value, bytes _data) public {
        emit TestLVTFallBack(_from, _value, _data);
    }
}