pragma solidity ^0.5.2;

contract DutchAuction {
    address payable author;
    uint decEach;
    uint decStep;
    uint startPrice;
    uint minPrice;
    uint actualPrice = 10e20;
    uint winBidAmount = 0;
    address payable winnerAddress;
    uint actualWinnerAmount;
    uint startBlock;
    
    constructor(address payable addr, uint _startPrice, uint _decEach, uint _decStep, uint _minPrice) payable public {
        require(
            _startPrice >= _minPrice,
            "Start price can't be less than minimum price."
        );
        author = addr;
        winnerAddress = author;
        startPrice = _startPrice;
        decEach = _decEach;
        decStep = _decStep;
        minPrice = _minPrice;
        startBlock = block.number;
    }
    
    function close() public {
        require(
            isActive() == false,
            "You can't close active auction."
        );
        require(
            msg.sender == author,
            "Only auction's owner can close it."
        );
        author.transfer(winBidAmount);
        selfdestruct(author);
    }
    
    function bid() payable public {
        require(
            isWinner() == false,
            "Sorry, we've already got the winner."
        );
        require(
            msg.value >= getPrice(),
            "Unfortunately actual price is higher, you may try again later or bid more."
        );
        winnerAddress = msg.sender;
        winBidAmount = actualPrice;
    }
    
    function getPrice() public returns (uint) {
        actualPrice = startPrice - (startBlock - block.number) / decEach * decStep; 
        return actualPrice;
    }
    
    function isActive() public returns (bool) {
        if (getPrice() >= minPrice) {
            return true;
        }
        else {
            return false;
        }
    }
    
    function isWinner() public returns (bool) {
        if (winnerAddress == author) {
            return false;
        }
        else {
            return true;
        }
    }
}
