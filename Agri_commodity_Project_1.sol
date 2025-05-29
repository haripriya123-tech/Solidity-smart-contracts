// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
contract AgriCommodities {
    enum State {Created, Harvested, Stored, Sold, Delivered}
 
    struct Commodity {
        uint id;
        string name;
        uint quantity;
        uint price;
        State state;
        address farmer;
        address buyer;
    }
 
    mapping(uint => Commodity) public commodities;
    uint public nextId;
 
    event CommodityCreated(uint id, string name, uint quantity, address farmer);
    event StateChanged(uint id, State state);
    event Sold(uint id, uint price, address buyer);
 
    // Farmer creates a commodity
    function createCommodity(string memory _name, uint _quantity) public {
        require(_quantity > 0, "Quantity must be greater than zero");
        commodities[nextId] = Commodity(nextId, _name, _quantity, 0, State.Created, msg.sender, address(0));
        emit CommodityCreated(nextId, _name, _quantity, msg.sender);
        nextId++;
    }
 
    // Farmer updates the state of the commodity
    function updateState(uint _id, State _state) public {
        Commodity storage commodity = commodities[_id];
        require(msg.sender == commodity.farmer, "Only farmer can update state");
        require(_state > commodity.state, "Cannot revert to previous state");
        commodity.state = _state;
        emit StateChanged(_id, _state);
    }
 
    // Buyer purchases the commodity
    function buyCommodity(uint _id) public payable {
        Commodity storage commodity = commodities[_id];
        require(commodity.state == State.Stored, "Commodity is not ready for sale");
        require(msg.value >= commodity.price, "Insufficient payment");
 
        // Transfer payment to the farmer (added this line)
        payable(commodity.farmer).transfer(msg.value);
        
        commodity.buyer = msg.sender;
        commodity.state = State.Sold;
        emit Sold(_id, commodity.price, msg.sender);
    }
 
    // Set price for a commodity (farmer only)
    function setPrice(uint _id, uint _price) public {
        Commodity storage commodity = commodities[_id];
        require(msg.sender == commodity.farmer, "Only farmer can set price");
        require(_price > 0, "Price must be greater than zero");
 
        commodity.price = _price;
    }
 
    // View details of a commodity
    function getCommodity(uint _id) public view returns (Commodity memory) {
        return commodities[_id];
    }
}