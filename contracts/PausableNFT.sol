// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract PausableNFT is ERC721Pausable, ERC721URIStorage, Ownable {
    /**
     * @dev
     * - _tokeIds はCountersの全関数が利用可能
     */
    using Counters for Counters.Counter;
    Counters.Counter private _tokeIds;
    
    /**
     * @dev
     * - URI 設定時に誰がどのTokenIdになんのURIを設定したか記録する
     */
    event TokenURIChanged(address indexed sender, uint256 indexed tokenId, string uri);

    constructor() ERC721("PausableNFT", "PAUSE") {}

    /**
     * @dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner が実行され _; を書くと nftMint に戻る.
     * - tokenId をインクリメント _tokeIds.increment()
     * - nftMint 関数の実行アドレスにtokenIdを紐付け
     * - mint の際にURIを設定 _setTokenURI()
     * - EVENT 発火 emit TokenURIChanged
     */
    function nftMint() public onlyOwner whenNotPaused() {
        _tokeIds.increment();
        uint256 newTokenId = _tokeIds.current();

        _mint(_msgSender(), newTokenId);

        string memory jsonFile = string(abi.encodePacked('metadata_', Strings.toString(newTokenId), '0.json'));

        _setTokenURI(newTokenId, jsonFile);
        emit TokenURIChanged(_msgSender(), newTokenId, jsonFile);
    }

    /**
     * @dev
     * - URI ブレフィックスの設定
     */
    function _baseURI() internal pure override returns (string memory){
        return "ipfs://bafybeid5l2mhmy5t4dme3ruqkemuvlxcdvtqsr25gv6idvgadlla7uy3wm/";
    }

    /**
     * @dev
     * - NFT 停止
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev
     * - NFT 停止の解除
     */
    function unpause() public onlyOwner {
        _unpause();
    }
    
    /**
     * @dev
     * - override
     */
    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal override(ERC721, ERC721Pausable) 
    {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }
    
    /**
     * @dev
     * - override
     */
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    /**
     * @dev
     * - override
     */
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev
     * - override
     */
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
