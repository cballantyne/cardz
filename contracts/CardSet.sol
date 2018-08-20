pragma solidity ^0.4.19;

import "./Ownable.sol";

contract CardSet is Ownable {

    string public name;

    event NewCard(uint cardId, string name, uint cardNum, uint instanceNum);

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
        cardToOwner[id] = msg.sender;
        ownerCardCount[msg.sender]++;
        NewCard(id, _name, _cardNum, _instanceNum);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function mintCards(string _name) public {
        // require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createCard(_name, 1, 1);
        // randDna = randDna - randDna % 100;
        // _createZombie(_name, randDna);
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


    function CardSet(address _owner, string _name)
    public
    {
        name = _name;
    }

}