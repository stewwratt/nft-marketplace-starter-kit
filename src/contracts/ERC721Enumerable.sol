//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

contract ERC721Enumerable is ERC721 {

    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    //mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        //2 things!
        //A. add tokens to the owner
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }
    
    //B. add tokens to our total supply - to all tokens
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        //set the position of the _allTokensIndex's
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);

    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        //A1 add address and token id to the _ownedTokens
        _ownedTokens[to].push(tokenId);

        //A2 ownedTokensIndex tokenId set to address of ownedTokens position
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;

        //A3 we want to execute the function with minting
    }

    //TWO MORE FUNCTIONS 
    //1. one that returns tokenByIndex
    function tokenByIndex(uint256 index) public view returns(uint256){
        //make sure that the index is not out of bounds of the total supply
        require(index < totalSupply(), 'Global index is out of bounds!');
        //return from the array all tokens
        return _allTokens[index];
    }
    //2. one that returns tokenOfOwnerByIndex
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns(uint256){
        //require that the address is valid

        return _ownedTokens[owner][index];
    }
    // return the total supply of the _allTokens array
    function totalSupply() public view returns(uint256) {
        return _allTokens.length;
    }

/*
    function _addTokensToOwnerStack(address to, uint256 tokenId) private {
        uint256[] memory ownerStack;
        ownerStack = 
    }
    */
}