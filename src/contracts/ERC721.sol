//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';
import './libraries/Counters.sol';
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

contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    // mapping in solidity creates a hash table of key pair values
    // mapping from tokenid to the owner
    mapping(uint256 => address) private _tokenOwner;

    // mapping from owner to number of owned tokens
    mapping(address => Counters.Counter) private _ownedTokensCount;
    //mapping(uint256 => bool) private _isMinted; //made this as an alternative to the _exists function from clarians solution
    mapping(uint256 => address) private _tokenApprovals;

    // register the interface for the erc721 so that it includes the following functions: balance of,
    // ownerOf, transferFrom
    // *note: by register the interface: write the constructors with
    // the according byte conversions
    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^
        keccak256('transferFrom(bytes4)')));
    } 

    function _exists(uint256 tokenId) internal view returns(bool) {
        // setting the address of nft owner to check the mapping
        // of the address from tokenOwner at the tokenId
        address owner = _tokenOwner[tokenId];
        // return trueness that the address is not zero
        return owner != address(0);
    }

    // this function is not safe
    // any type of mathematics can be held to dubious standards
    // in SOLIDITY (ADDITION OVERFLOW)
    //UPDATE: NOW IT IS SAFE because we implemented the counters
    function _mint(address to, uint256 tokenId) internal virtual {
        // requires that the address isn't zero
        require(to != address(0), 'Mint address is not an address!');
        // requires that the token does not already exist
        // require(!_isMinted[tokenId], 'This token has already been minted!'); my initial solution, since corrected
        require(!_exists(tokenId),'ERC721: token already minted');
        // we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        // increasing the count of an address' owned tokens
        _ownedTokensCount[to].increment();
        //_isMinted[tokenId] = true; part of my initial solution, since corrected
        

        // a log of the mint that has been performed
        emit Transfer(address(0), to, tokenId);
    }

    // 1. require that the person approving is the owner
    // 2. we are approving an address to a token (tokenId)
    // 3. require that we cant approve sending tokens of the owner to the owner(current caller)
    // 4. update the map of the approval addresses

    /* COME BACK TO THIS AFTER PROJ COMPLETION (APPROVAL FUNCTIONALITY lect. 144)
    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - Approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner of the token!');
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    }
    */

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), 'Token does not exist!');
        address owner = ownerOf(tokenId);
        return(spender == owner);
    }
    

     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer

    // this is not safe! safemath. UPDATE: NOW IT IS SAFE because we implemented the counters
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Error - ERC721 transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Error - Attempt to transfer a token the address does not own!');

        _ownedTokensCount[_from].decrement();
        _ownedTokensCount[_to].increment();

        _tokenOwner[_tokenId] = _to;
        
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external override {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public override view returns(uint256) {
        require(_owner != address(0), 'Error - Invalid address!');
        return _ownedTokensCount[_owner].current();
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint _tokenId) public override view returns(address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'Error - This token is invalid');
        return owner;
    }

}
