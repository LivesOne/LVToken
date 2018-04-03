pragma solidity ^0.4.11;

import "./ERC223_interface.sol";
import "./ERC20_functions.sol";
import "./ERC223_receiving_contract.sol";
import "./SafeMath.sol";

/**
 * @title Reference implementation of the ERC223 standard token.
 */
contract LVToken is ERC223Interface, ERC20CompatibleToken {
    using SafeMath for uint;

    string public constant name = "Lives One Token";
    string public constant symbol = "LVT";
    uint256 public constant decimals = 18;
    string public constant version = "2.0";
    // uint256 public totalSupply = 28 * (10**9) * 10**decimals;

    function LVToken() {
        totalSupply = 28 * (10**9) * 10**decimals;
        balances[0xd5a375Dd13abEF145B8183E6C2380BC777614395] = 28 * (10**8) * 10**decimals;              //team, 10%
        balances[0x22164b69c71DcF12E1dc037BB43933449f342a69] = 140 * (10**8) * 10**decimals;             //miner, 50%
        balances[0xBDC44A4EA8A9640ee5DcF2E0425d7A262C830c62] = 56 * (10**8) * 10**decimals;              //pre-ico, 20%
        balances[0x32A3A725895F1BdcFC1FEf8340f9f26d49Af60ab] = 56 * (10**8) * 10**decimals;              //organization, 20%        
    }
    /**
     * @dev Transfer the specified amount of tokens to the specified address.
     *      Invokes the `tokenFallback` function if the recipient is a contract.
     *      The token transfer fails if the recipient is a contract
     *      but does not implement the `tokenFallback` function
     *      or the fallback function to receive funds.
     *
     * @param _to    Receiver address.
     * @param _value Amount of tokens that will be transferred.
     * @param _data  Transaction metadata.
     */
    function transfer(address _to, uint _value, bytes _data) {
        // Standard function transfer similar to ERC20 transfer with no _data .
        // Added due to backwards compatibility reasons .
        uint codeLength;

        assembly {
            // Retrieve the size of the code on target address, this needs assembly .
            codeLength := extcodesize(_to)
        }

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        if(codeLength>0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        emit Transfer(msg.sender, _to, _value, _data);
    }

    /**
     * @dev Transfer the specified amount of tokens to the specified address.
     *      This function works the same with the previous one
     *      but doesn't contain `_data` param.
     *      Added due to backwards compatibility reasons.
     *
     * @param _to    Receiver address.
     * @param _value Amount of tokens that will be transferred.
     */
    function transfer(address _to, uint _value) {
        uint codeLength;
        bytes memory empty;

        assembly {
            // Retrieve the size of the code on target address, this needs assembly .
            codeLength := extcodesize(_to)
        }

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        if(codeLength>0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, empty);
        }
        emit Transfer(msg.sender, _to, _value, empty);
    }


    /**
     * @dev Returns balance of the `_owner`.
     *
     * @param _owner   The address whose balance will be returned.
     * @return balance Balance of the `_owner`.
     */
    function balanceOf(address _owner) constant returns (uint balance) {
        return balances[_owner];
    }
}
