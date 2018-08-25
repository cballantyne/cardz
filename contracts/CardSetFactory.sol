pragma solidity ^0.4.19;
import "./Factory.sol";
import "./CardSet.sol";


/// @title CardSet factory - Allows creation ofcardset.
contract CardSetFactory is Factory {
    /*
     * Public functions
     */
    /// @param _name Name of CardSet
    /// @return Returns cardset address.
    function create(string _name)
    public
    returns (address cardSet)
    {
        address _owner = msg.sender;
        cardSet = new CardSet(msg.sender, _name);
        register(cardSet);
    }

}