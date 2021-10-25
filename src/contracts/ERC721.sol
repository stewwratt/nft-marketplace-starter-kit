//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
 /*
    Building out the mint function:
        1. NFT to point to an address
        2. Keep track of the Token ids
        3. Keep track of token owner address to token ids
        4. Keep track of how many tokens an owner address has
        5. emit transfer logs - contract address, where its being 
            minted to, the token id

    1. write a function mint that takes two arguments
    2. add internal visibility to the signature
    3. set the tokenOwner of the tokenID to the address
    4. increase the owner token count by 1 each time the function is called
*/

contract ERC721 {
    
    // a log of our minting funcuinction
    event Transfer(
        address indexed from, 
        address indexed to, 
        uint256 indexed tokenId);

    // mapping in solidity creates a hash table of key pair values

    // mapping from tokenid to the owner
    mapping(uint256 => address) private _tokenOwner;

    // mapping from owner to number of owned tokens
    mapping(address => uint256) private _ownedTokensCount;
    //mapping(uint256 => bool) private _isMinted; //made this as an alternative to the _exists function from clarians solution

    function _exists(uint256 tokenId) internal view returns(bool) {
        // setting the address of nft owner to check the mapping
        // of the address from tokenOwner at the tokenId
        address owner = _tokenOwner[tokenId];
        // return trueness that the address is not zero
        return owner != address(0);
    }


    function _mint(address to, uint256 tokenId) internal virtual {
        // requires that the address isn't zero
        require(to != address(0), 'Mint address is not an address!');
        // requires that the token does not already exist
        // require(!_isMinted[tokenId], 'This token has already been minted!'); my initial solution, since corrected
        require(!_exists(tokenId),'ERC721: token already minted');
        // we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        // increasing the count of an address' owned tokens
        _ownedTokensCount[to] += 1;
        //_isMinted[tokenId] = true; part of my initial solution, since corrected
        
        // a log of the mint that has been performed
        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner != address(0), 'Error - Invalid address!');
        return _ownedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint _tokenId) public view returns(address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'Error - This token is invalid');
        return owner;
    }

}
