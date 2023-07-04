// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
struct NFTListing {
    uint256 price;
    address seller;
}

contract NFTMarket is ERC721URIStorage , Ownable{
    using Counters for Counters.Counter;
    using SafeMath for uint256;
    Counters.Counter private _tokenIds;
mapping(uint256 => NFTListing) private _listing;


event NFTTransfer(uint256 tokenID, address from, address to , string  tokenURI, uint256 price);

    constructor() ERC721("Abdou's, NFT's", "ANFT") {}

    function createNFT(string calldata tokenURI) public returns(uint256){
        _tokenIds.increment();
        uint256 currentID = _tokenIds.current();
        _safeMint(msg.sender, currentID);
        _setTokenURI(currentID,tokenURI);
        return currentID;
         emit NFTTransfer(currentID ,address(0) ,msg.sender, tokenURI, 0);
    }

    function listNFT(uint256 tokenID, uint256 price)  public payable {
        require(price > 0 , "NFTMaket: price must be greater than 0");
        transferFrom(msg.sender, address(this),tokenID);
        _listing[tokenID] = NFTListing(price,msg.sender);
        emit NFTTransfer(tokenID,address(0) ,address(this), "", price);
    }

    function buyNFT(uint256 tokenID) public payable{
         NFTListing memory listing = _listing[tokenID];
        require(listing.price > 0 , "NFTMaket: nft not listed for sale");
        require(msg.value == listing.price,"NFTMarket: incorrect price");
        ERC721(address(this)).transferFrom(address(this), msg.sender,tokenID);
        clearListing(tokenID);
        payable(listing.seller).transfer(listing.price.mul(95).div(100));
        emit NFTTransfer(tokenID,address(this), msg.sender, "", 0);
    }

    function cancelListing(uint256 tokenID) public {
         NFTListing memory listing = _listing[tokenID];
        require(listing.price > 0 , "NFTMaket: nft not listed for sale");
        require(listing.seller == msg.sender ,"NFTMarket: you're not owner");
        ERC721(address(this)).transferFrom(address(this), msg.sender,tokenID);
        clearListing(tokenID);
        payable(msg.sender).transfer(listing.price.mul(95).div(100));
        emit NFTTransfer(tokenID,address(this), msg.sender, "", 0);
    }

    function withdrawFunds() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0 , "NFTMarket: balance is zero");
        payable(owner()).transfer(balance);
    }

    function clearListing(uint256 tokenID) private{
        _listing[tokenID].price = 0;
        _listing[tokenID].seller = address(0);
    }

}
