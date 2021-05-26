// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TokenOneMinter is ERC721("TokenOne", "one") {
    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }
}