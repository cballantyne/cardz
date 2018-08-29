pragma solidity ^0.4.19;

import "./Ownable.sol";

contract CardSet is Ownable {

    string public name;

    event CardsMinted(string name, uint cardNum, uint instanceCount);
    event CardMinted(uint cardId, string name, uint cardNum, uint instanceNum);
    event CardBought(uint cardId, address owner);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Card {
        string name;
        uint16 cardNum;
        uint16 instanceNum;
    }

    Card[] public cards;

    mapping (uint => address) public cardToOwner;
    mapping (address => uint) ownerCardCount;


    function _createCard(string _name, uint16 _cardNum, uint16 _instanceNum) internal {
        uint id = cards.push(Card(_name, _cardNum, _instanceNum)) - 1;
        CardMinted(id, _name, _cardNum, _instanceNum);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function _generateRandomNumber(uint _max) private view returns (uint) {
        uint rand = uint(keccak256(now + uint(msg.sender)));
        return rand % _max;
    }

    function getUnownedCardsCount() public view returns (uint) {
        uint count = 0;
        for (uint i = 0; i < cards.length; i++) {
            if (cardToOwner[i] == 0) {
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

    function mintCards(string _name, uint16 _instanceCount) public onlyOwner {
        // require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);

        // randDna = randDna - randDna % 100;
        // _createZombie(_name, randDna);
        uint16 nextCardNum = getUniqueCardsCount() + 1;

        for (uint16 i = 1; i <= _instanceCount; i++) {
            _createCard(_name, nextCardNum, i);
        }
        CardsMinted(_name, nextCardNum, _instanceCount);
    }

    function buyCard(uint _cardId) public {
        //security so can only buy unowned cards.
        require(cardToOwner[_cardId] == 0);

        cardToOwner[_cardId] = msg.sender;
        ownerCardCount[msg.sender]++;
        CardBought(_cardId, msg.sender);
    }

    function buyRandomCard() public {
        uint[] memory unownedCards = getCardsUnowned();
        if (unownedCards.length-1 == 0) {
            buyCard(unownedCards[0]);
        } else {
            uint cardIdToBuy = unownedCards[_generateRandomNumber(unownedCards.length-1)];
            buyCard(cardIdToBuy);
        }
    }

    function getCardsByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](ownerCardCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < cards.length; i++) {
            if (cardToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function getCardsUnowned() public view returns(uint[]) {
        uint cardsUnownedCount = getUnownedCardsCount();
        uint[] memory result = new uint[](cardsUnownedCount);
        uint counter = 0;
        for (uint i = 0; i < cards.length; i++) {
            if (cardToOwner[i] == 0) {
                result[counter] = i;
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