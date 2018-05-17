pragma solidity ^0.4.10;
import './AbstractToken.sol';
import './SafeMath.sol';

/// @title Standard token contract - Standard token interface implementation
contract StandardToken is Token {
  using SafeMath for uint256;
    /*
     *  Storage
     */
    mapping (address => mapping(uint256=>uint256)) public balances; //address, val
    mapping (address => mapping(uint256=>uint256)) public coinval; //address, key
    mapping (address => mapping(uint256=>bool)) public valOwned; // address val
    mapping(address=>uint256) coinvalsOwned;

    mapping (address => mapping (address => uint256)) public allowances;
    uint256 public totalSupply;

    /*
     *  Public functions
     */
    /// @dev Transfers sender's tokens to a given address. Returns success
    /// @param to Address of token receiver
    /// @param value Number of tokens to transfer
    /// @return Returns success of function call
    function transfer(address to, uint256 value,uint val)
        public
        returns (bool)
    {
        //require(to != address(0));

        require(value <= balances[msg.sender][val]);
        balances[msg.sender][val] = balances[msg.sender][val].sub(value);
        balances[to][val] = balances[to][val].add(value);

        uint t=coinvalsOwned[to];
        if(valOwned[to][val]==false){
          coinvalsOwned[to]+=1;
          coinval[to][t]=val;
          valOwned[to][val]=true;
        }


        Transfer(msg.sender, to, value,val);
        return true;
    }

    /// @dev Allows allowances third party to transfer tokens from one address to another. Returns success
    /// @param from Address from where tokens are withdrawn
    /// @param to Address to where tokens are sent
    /// @param value Number of tokens to transfer
    /// @return Returns success of function call
    function transferFrom(address from, address to, uint256 value,uint val)
        public
        returns (bool)
    {
        // if (balances[from] < value || allowances[from][msg.sender] < value)
        //     // Balance or allowance too low
        //     revert();
        //require(to != address(0));
        require(value <= balances[from][val]);
        require(value <= allowances[from][msg.sender]);
        balances[to][val] = balances[to][val].add(value);
        balances[from][val] = balances[from][val].sub(value);

        uint t=coinvalsOwned[to];
        if(valOwned[to][val]==false){
          coinvalsOwned[to]+=1;
          coinval[to][t]=val;
          valOwned[to][val]=true;
        }

        allowances[from][msg.sender] = allowances[from][msg.sender].sub(value);
        Transfer(from, to, value,val);
        return true;
    }

    /// @dev Sets approved amount of tokens for spender. Returns success
    /// @param _spender Address of allowances account
    /// @param value Number of approved tokens
    /// @return Returns success of function call
    function approve(address _spender, uint256 value)
        public
        returns (bool success)
    {
        require((value == 0) || (allowances[msg.sender][_spender] == 0));
        allowances[msg.sender][_spender] = value;
        Approval(msg.sender, _spender, value);
        return true;
    }

 /**
   * approve should be called when allowances[_spender] == 0. To increment
   * allowances value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   */
    function increaseApproval(address _spender, uint _addedValue)
        public
        returns (bool)
    {
        allowances[msg.sender][_spender] = allowances[msg.sender][_spender].add(_addedValue);
        Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(address _spender, uint _subtractedValue)
        public
        returns (bool)
    {
        uint oldValue = allowances[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowances[msg.sender][_spender] = 0;
        } else {
            allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
        return true;
    }

    /// @dev Returns number of allowances tokens for given address
    /// @param _owner Address of token owner
    /// @param _spender Address of token spender
    /// @return Returns remaining allowance for spender
    function allowance(address _owner, address _spender)
        public
        constant
        returns (uint256)
    {
        return allowances[_owner][_spender];
    }

    /// @dev Returns number of tokens owned by given address
    /// @param _owner Address of token owner
    /// @return Returns balance of owner
    function balanceOf(address _owner,uint val)
        public
        constant
        returns (uint256)
    {
        return balances[_owner][val];
    }
}
