pragma solidity ^0.4.19;
import "./Factory.sol";
import "./CardSet.sol";


/// @title CardSet factory - Allows creation ofcardset.
contract CardSetFactory is Factory {
    /*
     * Public functions
     */
    /// @param _owner Owner of CardSet.
    /// @param _name Name of CardSet
    /// @return Returns cardset address.
    function create(address _owner, string _name)
    public
    returns (address cardSet)
    {
        cardSet = new CardSet(_owner, _name);
        register(cardSet);
    }

}