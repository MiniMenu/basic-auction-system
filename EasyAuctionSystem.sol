// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract BasicAuctionSystem { 
    error BasicAuctionSystem__BidAmountLowerThanCurrentBid();
    error BasicAuctionSystem__InvalidItemId();

    struct Item {
        string name;
        string description;
        uint256 currentHighestBid;
        address higgestBidder;
    }

    mapping(uint=>Item) private listOfItems;

    uint private itemId;
    address private auctioneer;
    
    constructor() {
        auctioneer = msg.sender;
    }

    modifier onlyAuctioneer {
        require(auctioneer == msg.sender, "You are not the Auctioneer");
        _;
    }

    modifier onlyBidder {
        require(auctioneer != msg.sender, "You are not a Bidder");
        _;
    }

    function addItemsForBidding(string memory _name,string memory _desc) public onlyAuctioneer{
       listOfItems[itemId] = Item(_name, _desc, 0, msg.sender);     
       itemId++;
    }

    function placeBids(uint256 _itemId, uint256 _bidAmount) public onlyBidder{
        if (_itemId > itemId) {
            revert BasicAuctionSystem__InvalidItemId();
        }
        Item memory item = listOfItems[_itemId];

        if (item.currentHighestBid > _bidAmount){
           revert BasicAuctionSystem__BidAmountLowerThanCurrentBid();
        }
        
        if (listOfItems[_itemId].higgestBidder != address(0)){
            payable(listOfItems[_itemId].higgestBidder).transfer(listOfItems[_itemId].currentHighestBid);
        }

        listOfItems[_itemId].currentHighestBid  = _bidAmount;
        listOfItems[_itemId].higgestBidder  = msg.sender; 
     

    }

    function currentHighestBidder(uint256 _itemId) public view returns(address, uint256) {
        return (listOfItems[_itemId].higgestBidder, listOfItems[_itemId].currentHighestBid);
    }

    function getItemDetails() public  view returns (Item[] memory){
         Item[] memory itemList = new Item[](itemId);   
         for (uint i = 0; i < itemId; i++) {
             itemList[i] = Item(listOfItems[i].name, listOfItems[i].description , listOfItems[i].currentHighestBid, listOfItems[i].higgestBidder);
         }

         return itemList;
    }
}