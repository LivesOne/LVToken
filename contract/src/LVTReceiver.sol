pragma solidity ^0.4.11;
 
contract LVTReceiver { 
    function tokenFallback(address _from, uint _value, bytes _data) public;
}
