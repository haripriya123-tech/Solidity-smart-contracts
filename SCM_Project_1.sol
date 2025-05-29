// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
contract ProvenanceTracker {
    struct Product {
        uint256 id;
        string name;
        string origin;
        string[] history;
    }
 
    mapping(uint256 => Product) private products;
    uint256 private productCount;
 
    event ProductCreated(uint256 id, string name, string origin);
    event ProductUpdated(uint256 id, string update);
 
    // Function to create a new product
    function createProduct(string memory _name, string memory _origin) public {
        productCount++;
        products[productCount] = Product(productCount, _name, _origin, new string[](0));
        emit ProductCreated(productCount, _name, _origin);
    }
 
    // Function to update the product's history
    function updateProduct(uint256 _id, string memory _update) public {
        require(_id > 0 && _id <= productCount, "Product ID is invalid.");
        products[_id].history.push(_update);
        emit ProductUpdated(_id, _update);
    }
 
    // Function to retrieve product details
    function getProduct(uint256 _id) public view returns (string memory, string memory, string[] memory) {
        require(_id > 0 && _id <= productCount, "Product ID is invalid.");
        Product storage product = products[_id];
        return (product.name, product.origin, product.history);
    }
}
 