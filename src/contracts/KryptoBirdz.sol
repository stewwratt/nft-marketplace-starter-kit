//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector{

    // array to store our nfts
    string[] public KryptoBirdz;

    //Initialises this contract to inherit name and symbol from ERC721Metadata'
    //so that the name is KryptoBird and symbol is KBIRDZ
    constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {

    }

    function mint(string memory _kryptoBird) public {
        // this is deprecated uint _id = KryptoBirdz.push(_kryptoBird);
        // .push no longer returns the length but a ref to the added element

        KryptoBirdz.push(_kryptoBird);
        uint _id = KryptoBirdz.length - 1;
        _mint(msg.sender, _id);
    }

}