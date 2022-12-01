//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {

    ICryptoDevs cryptoDevsNFT;
    mapping (uint256 => bool) public tokenIdsClaimed;
    uint256 public constant tokensPerNFT = 10 * 10**18;

    uint256 public constant maxTotalSupply = 10000 * 10**18;
    uint256 public constant tokenPrice = 0.001 ether;

    constructor (address _cryptoDevsContract) ERC20 ("Crypto Dev Token", "CD"){
        cryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    //claim for those that have CryptoDev NFT
    //should have an NFT -> for each NFT, 10 CD tokens to claim
    //Should be able to claim only once
    //tokens should not be more than 10,000
    function claim() public {
        address sender = msg.sender;
        uint256 balance = cryptoDevsNFT.balanceOf(sender);

        require(balance > 0, "You are not eligible to claim");

        uint256 amount = 0; //tells the unclaimed amount left

        for (uint256 i = 0; i < balance; i++){
            uint256 tokenId = cryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
            if(!tokenIdsClaimed[tokenId]){
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }

        require(amount > 0, "You have already claimed all your tokens");
        _mint(msg.sender, amount * tokensPerNFT);
    }

    function mint(uint256 amount) public payable{
        
      uint256 requiredAmountOfEther = tokenPrice * amount;
      require(msg.value > requiredAmountOfEther, "Ether sent is incorrect");
      uint256 amountWithDecimals = amount * 10**18;
      require(
        totalSupply() + amountWithDecimals <= maxTotalSupply,
        "exeeds total supply value"
      );
      _mint(msg.sender, amountWithDecimals);
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "Nothing to withdraw; contract balance empty");
        
        address _owner = owner();
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
      }



    receive() external payable{}

    fallback() external payable{}
}
