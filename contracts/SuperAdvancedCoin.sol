// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract QuantumReserveToken is
    ERC20Burnable,
    ERC20Capped,
    ERC20Permit,
    Pausable,
    AccessControl,
    Ownable
{
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // Optional blacklist mapping for regulatory compliance
    mapping(address => bool) public blacklisted;

    constructor(
        string memory name,
        string memory symbol,
        uint256 cap
    )
        ERC20(name, symbol)
        ERC20Capped(cap)
        ERC20Permit(name)
        Ownable(msg.sender)
    {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);

        _mint(msg.sender, cap); // Mint full supply to owner
    }

    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        require(!blacklisted[to], "Blacklisted");
        _mint(to, amount);
    }

    function setBlacklist(address user, bool value) external onlyOwner {
        blacklisted[user] = value;
    }

    // Overriding _update for OpenZeppelin 5 compatibility
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Capped)
    {
        require(!paused(), "Token is paused");
        require(!blacklisted[from] && !blacklisted[to], "Blacklisted address");

        super._update(from, to, value);
    }
}
