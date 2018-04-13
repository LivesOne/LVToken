pragma solidity ^0.4.11;

import "./LVTReceiver.sol";

contract TestLVTReceiver is LVTReceiver {
    event TestLVTFallBack(address indexed _sender, address indexed _from, uint _value, bytes indexed _data);
    function tokenFallback(address _from, uint _value, bytes _data) public {
        emit TestLVTFallBack(msg.sender, _from, _value, _data);
    }
}