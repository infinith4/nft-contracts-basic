// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CounterNFT is ERC721URIStorage, Ownable {
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

    constructor() ERC721("CounterNFT", "COUNT") {}

    /**
     * @dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner が実行され _; を書くと nftMint に戻る.
     * - tokenId をインクリメント _tokeIds.increment()
     * - nftMint 関数の実行アドレスにtokenIdを紐付け
     * - mint の際にURIを設定 _setTokenURI()
     * - EVENT 発火 emit TokenURIChanged
     */
    function nftMint() public onlyOwner {
        _tokeIds.increment();
        uint256 newTokenId = _tokeIds.current();

        _mint(_msgSender(), newTokenId);

        string memory jsonFile = string(abi.encodePacked('metadata_', Strings.toString(newTokenId), '0.json'));

        _setTokenURI(newTokenId, jsonFile);
        emit TokenURIChanged(_msgSender(), newTokenId, jsonFile);
    }

    function _baseURI() internal pure override returns (string memory){
        return "ipfs://bafybeid5l2mhmy5t4dme3ruqkemuvlxcdvtqsr25gv6idvgadlla7uy3wm/";
    } 
}
