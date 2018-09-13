pragma solidity ^0.4.19;

import "./Ownable.sol";
import "./ERC721Enumerable.sol";

contract CardSet is Ownable, ERC721Enumerable {

    string public name;

    event CardsMinted(string name, uint cardNum, uint instanceCount);
    event CardMinted(uint cardId, string name, uint cardNum, uint instanceNum);

    struct Card {
        string name;
        uint16 cardNum;
        uint16 instanceNum;
    }

    Card[] public cards;


    function _createCard(string _name, uint16 _cardNum, uint16 _instanceNum) internal {
        uint id = cards.push(Card(_name, _cardNum, _instanceNum)) - 1;
        super._mint(msg.sender, id);
        emit CardMinted(id, _name, _cardNum, _instanceNum);
    }

    function getUniqueCardsCount() public view returns (uint16) {
        uint16 cardNum = 0;
        if (cards.length > 0) {
            cardNum = uint16(cards[cards.length-1].cardNum);
        }
        return cardNum;
    }

    function mintCards(string _name, uint16 _instanceCount) public onlyContractOwner {
        uint16 nextCardNum = getUniqueCardsCount() + 1;

        for (uint16 i = 1; i <= _instanceCount; i++) {
            _createCard(_name, nextCardNum, i);
        }
        emit CardsMinted(_name, nextCardNum, _instanceCount);
    }

    function getCardsByOwner(address _owner) public view returns(uint[]) {
        uint[] memory result = new uint[](balanceOf(_owner));
        for (uint i = 0; i < balanceOf(_owner); i++) {
            result[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return result;
    }

    constructor(address _owner, string _name)
    public
    {
        name = _name;
        owner = _owner;
    }

}