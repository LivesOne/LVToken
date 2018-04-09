pragma solidity ^0.4.10;

contract LVToken {
    string public constant name = "Lives One Token";
    string public constant symbol = "LVT";
    uint public constant decimals = 18;
    string public constant version = "1.0";

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;

    bool public freezed = false;
    mapping (address => uint) permits;
    address public constant addr_team = 0xd5a375Dd13abEF145B8183E6C2380BC777614395;
    address public constant addr_miner = 0x22164b69c71DcF12E1dc037BB43933449f342a69;
    address public constant addr_ico = 0xBDC44A4EA8A9640ee5DcF2E0425d7A262C830c62;
    address public constant addr_org = 0x32A3A725895F1BdcFC1FEf8340f9f26d49Af60ab;

    uint public totalSupply = 28 * (10**9) * 10**decimals;

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    event Freeze(address indexed _from, uint _sum);

    function LVToken() public {
        balances[addr_team] = 28 * (10**8) * 10**decimals;              //team, 10%
        balances[addr_miner] = 140 * (10**8) * 10**decimals;             //miner, 50%
        balances[addr_ico] = 56 * (10**8) * 10**decimals;              //pre-ico, 20%
        balances[addr_org] = 56 * (10**8) * 10**decimals;              //organization, 20%

        permits[addr_team] = 0;
        permits[addr_miner] = 0;
        permits[addr_ico] = 0;
        permits[addr_org] = 0;
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        require(!freezed);
        require(_value > 0);
        require(balances[msg.sender] >= _value);

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require(!freezed);
        require(_value > 0);
        require(balances[_from] >= _value);
        require(allowed[_from][msg.sender] >= _value);

        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
    }

    function balanceOf(address _owner) constant public returns (uint balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint _value) public returns (bool success) {
        require(!freezed);
        
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant public returns (uint remaining) {
        return allowed[_owner][_spender];
    }

    function freeze() public {
        require(!freezed);
        require(msg.sender == addr_team || msg.sender == addr_miner || msg.sender == addr_ico || msg.sender == addr_org);
        
        permits[msg.sender] = 1;
        uint sum = permits[addr_team] + permits[addr_miner] + permits[addr_ico] + permits[addr_org];
        if (sum >= 2) {
          freezed = true;
        }
        emit Freeze(msg.sender, sum);
    }
}
