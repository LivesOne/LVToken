pragma solidity ^0.4.11;


library SafeMath {
    function mul(uint a, uint b) pure internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint a, uint b) pure internal returns (uint) {
        uint c = a / b;
        return c;
    }

    function sub(uint a, uint b) pure internal returns (uint) {
        require(b <= a);
        return a - b;
    }

    function add(uint a, uint b) pure internal returns (uint) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }
}
