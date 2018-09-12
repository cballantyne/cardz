var tradingCardShopAbi =
    [
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_cardSetAddress",
                    "type": "address"
                }
            ],
            "name": "buyRandomCard",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "cardId",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "owner",
                    "type": "address"
                }
            ],
            "name": "CardBought",
            "type": "event"
        }
    ]