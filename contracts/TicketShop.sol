// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "../interfaces/CatalogItems.sol";

contract TicketShop is AccessControl
{
    bytes32 public constant GAME_ROLE = keccak256("GAME_ROLE");

    IERC20 immutable token_tix;
    
    CatalogItem[] public catalog;

    constructor(address contractTIX)
    {
        token_tix = IERC20(contractTIX);
    }

    //TODO: Consider pausing the contract when updating the catalog to avoid update/claim race conditions.
    function claim(uint16 catalogIndex, address tixHolder) public onlyRole(GAME_ROLE)
    {
        require(catalogIndex < catalog.length);

        CatalogItem memory prize = catalog[catalogIndex];

        require(!prize.claimed, "Prize is already claimed!");
        require(token_tix.balanceOf(tixHolder) >= prize.price);
        require(token_tix.allowance(tixHolder, address(this)) >= prize.price);

        //TODO: Should the ticketshop serve as TIX treasury? Let's say yes for now...

        token_tix.transferFrom(tixHolder, address(this), prize.price); // Consume TIX.

        grantPrize(prize, tixHolder); // Transfer reward.

        prize.claimed = true;
    }

    function grantPrize(CatalogItem memory prize, address recipient) private
    {
        if(prize.itemType == CatalogItemTypes.ERC721)
        {
            IERC721 token = IERC721(prize.itemContract);
            token.transferFrom(address(this), recipient, uint256(prize.userDataBuffer));
        }
    }
}
