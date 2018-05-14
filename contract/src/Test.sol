pragma solidity ^0.4.11;

contract LVTokenFake {
  function balanceOf(address _owner) constant public returns (uint);
}

contract Test {
  // uint public bal = 0;

  function getBal(address c, address u) constant public returns (uint) {
    LVTokenFake t = LVTokenFake(c);
    return t.balanceOf(u);
  }
}