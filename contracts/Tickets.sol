// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Ticket is ERC20, Pausable, AccessControl {
    
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE"); // To allow emergency stop of the contract.
    bytes32 public constant GRANT_ROLE = keccak256("GRANT_ROLE"); // To grant TIX payout from a game session.

    constructor() ERC20("Ticket", "TIX") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
    }

    // Limiting transfer permissions to specific roles (only games & ticket shop).
    function transfer(address recipient, uint256 amount) public onlyRole(GRANT_ROLE) override returns (bool) 
    {
        return super.transfer(recipient, amount);
    }
    
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
