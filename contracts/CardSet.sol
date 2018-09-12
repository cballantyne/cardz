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
        CardMinted(id, _name, _cardNum, _instanceNum);
    }

  

    function getUnownedCardsCount() public view returns (uint) {
        uint count = 0;
        for (uint i = 0; i < totalSupply(); i++) {
            if (ownerOf(tokenByIndex(i)) == 0) {
                count++;
            }
        }
        return count;
    }

    function getUniqueCardsCount() public view returns (uint16) {
        uint16 cardNum = 0;
        if (cards.length > 0) {
            cardNum = uint16(cards[cards.length-1].cardNum);
        }
        return cardNum;
    }

    function mintCards(string _name, uint16 _instanceCount) public onlyContractOwner {
        // require(ownerZombieCount[msg.sender] == 0);
        //uint randDna = _generateRandomDna(_name);

        // randDna = randDna - randDna % 100;
        // _createZombie(_name, randDna);
        uint16 nextCardNum = getUniqueCardsCount() + 1;

        for (uint16 i = 1; i <= _instanceCount; i++) {
            _createCard(_name, nextCardNum, i);
        }
        CardsMinted(_name, nextCardNum, _instanceCount);
    }


    function getCardsByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](balanceOf(_owner));
        for (uint i = 0; i < balanceOf(_owner); i++) {
            result[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return result;
    }

    function getCardsUnowned() public view returns(uint[]) {
        uint cardsUnownedCount = getUnownedCardsCount();
        uint[] memory result = new uint[](cardsUnownedCount);
        uint counter = 0;
        for (uint i = 0; i < totalSupply(); i++) {
            if (ownerOf(tokenByIndex(i)) == 0) {
                result[counter] = tokenByIndex(i);
                counter++;
            }
        }
        return result;
    }


    function CardSet(address _owner, string _name)
    public
    {
        name = _name;
        owner = _owner;
    }

}