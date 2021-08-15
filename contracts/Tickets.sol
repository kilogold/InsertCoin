// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Ticket is ERC20, ERC20Burnable, ERC20Permit, Pausable, AccessControl
{
    // To allow emergency stop of the contract.
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    
    // Only smart contracts with this role are allowed to spend/transfer on behalf of the user.
    // This role is designed to restrict secondary market behaviors, such as providing liquidity for a DEX.
    // The restriction is necessary to avoid pay-to-win scenarios when redeeming tickets at the ticket shop.
    // The only time a game should be consiered for this role is for creative use-cases when TIX are used as input/payment.
    bytes32 public constant SPENDER_ROLE = keccak256("SPENDER_ROLE");

    constructor() ERC20("Ticket", "TIX") ERC20Permit("Ticket")
    {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
    }
        
    function mint(address to, uint256 amount) public onlyRole(DEFAULT_ADMIN_ROLE) 
    {
        _mint(to, amount);
    }

    // Limiting transfer permissions to specific roles (only games & ticket shop).
    function _approve(address owner, address spender, uint256 amount) internal onlyRole(SPENDER_ROLE) override 
    {
        super._approve(owner,spender,amount);
    }
    
    function pause() public onlyRole(PAUSER_ROLE)
    {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) 
    {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
