// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    /**
     * @dev
     * - このコントラクトをデプロイしたアドレス用変数owner
     */
    address public owner;

    constructor() ERC721("OnlyOwnerMint", "OWNER"){
        owner = _msgSender();
    }

    /**
     * @dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 require
     * - nftMint 関数の実行アドレスにtokenIdを紐付け
     */
    function nftMint(uint256 tokenId) public {
        require(owner == _msgSender(), "Caller is not the owner.");
        _mint(_msgSender(), tokenId);
    }
}
