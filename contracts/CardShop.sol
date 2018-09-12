pragma solidity ^0.4.19;

import "./CardSet.sol";

contract CardShop {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;
    
    event CardBought(uint cardId, address owner);
    
      function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function _generateRandomNumber(uint _max) private view returns (uint) {
        uint rand = uint(keccak256(now + uint(msg.sender)));
        return rand % _max;
    }
    
    function _buyCard(address _cardSetAddress, uint _cardId) internal {
        CardSet cardSet = CardSet(_cardSetAddress);
        
        cardSet.transferFrom(this, msg.sender, _cardId);

        CardBought(_cardId, msg.sender);
    }

    function buyRandomCard(address _cardSetAddress) external {
        
        
        CardSet cardSet = CardSet(_cardSetAddress);
        
        uint[] memory unownedCards = cardSet.getCardsUnowned();
        if (unownedCards.length-1 == 0) {
            _buyCard(_cardSetAddress, unownedCards[0]);
        } else {
            uint cardIdToBuy = unownedCards[_generateRandomNumber(unownedCards.length-1)];
            _buyCard(_cardSetAddress, cardIdToBuy);
        }
    }
    
} 