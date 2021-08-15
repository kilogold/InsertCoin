// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/************************************************************************************
Prizes are indexed via hosted json metadata (like NFT's), which contain the following info:
{
    "Price": 123,
    "Type": "ERC721",
    "TokenAddress": "0x123456789ABCDEF"
    "TokenID": "1"
    "Thumbnail" : "ipfs://thumb.png"
}
*************************************************************************************/
enum CatalogItemTypes
{
    ERC721,
    ERC1155,
    ERC20
}

struct CatalogItem
{
    CatalogItemTypes itemType;
    address itemContract;
    uint256 price;
    //string metadataURI; -- Let's skip metadata for now. That might involve oracles...
    uint256 userDataBuffer;
    bool claimed;
}