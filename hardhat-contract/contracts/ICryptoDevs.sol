//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//maximum number of tokens - 10,000
//Holders of cryptoDev NFT should get 10 tokens for free
//Price of one CD at the time of ICO - 0.001 ether


interface ICryptoDevs {
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    function balanceOf(address owner) external view returns (uint256 balance); 
}