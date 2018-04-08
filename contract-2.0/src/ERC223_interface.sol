pragma solidity ^0.4.11;

contract ERC223Interface {
    function balanceOf(address who) public view returns (uint);
    function transfer(address to, uint value) public;
    function transfer(address to, uint value, bytes data) public;
    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}
