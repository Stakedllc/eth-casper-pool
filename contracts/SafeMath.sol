pragma solidity ^0.4.10;

/// @title SafeMath
/// @dev Math operations with safety checks that throw on error
library SafeMath {
    /// @dev Multiplies a times b
    function mul(uint256 a, uint256 b)
    internal
    pure
    returns (uint256)
    {
        uint256 c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    /// @dev Divides a by b
    function div(uint256 a, uint256 b)
    internal
    pure
    returns (uint256)
    {
        // require(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // require(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /// @dev Subtracts a from b
    function sub(uint256 a, uint256 b)
    internal
    pure
    returns (uint256)
    {
        require(b <= a);
        return a - b;
    }

    /// @dev Adds a to b
    function add(uint256 a, uint256 b)
    internal
    pure
    returns (uint256)
    {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}
