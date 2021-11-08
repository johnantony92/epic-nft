// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";


contract MyEpicNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

string baseSvg="<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width='100%' height='100%' fill='black' /><text  y='50%' font-size='15' dy='0' class='base' dominant-baseline='middle'><tspan x='50%' dy='.6em'>";
string lineCompSvg="</tspan><tspan x='50%' dy='1.2em'>";
string svgEnding="</tspan></text></svg>";

string[] creatures = ["Monster", "Animal", "Amphibian", "HUman"];
string[] powers = ["SuperSound", "Fly", "FirePower", "PowerPunch"];
string[] outlooks = ["BigHat", "BackThrobe", "Armour", "BigShoes"];

event NewEpicNFTMinted(address sender, uint256 tokenId);


  constructor() ERC721 ("SuperPowerNFT", "SUPERPOWERBUCKET") {
    console.log("This is my NFT contract. Woah!");
  }

  function pickRandomFirstWord(uint256 tokenId)public view returns(string memory){
    uint256 rand=random(string(abi.encodePacked("creature",Strings.toString(tokenId))));
    rand=rand % creatures.length;
    return creatures[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("power", Strings.toString(tokenId))));
    rand = rand % powers.length;
    return powers[rand];
  }

  function pickRandomThirdWord(uint256 tokenId)public view returns(string memory){
    uint256 rand=random(string(abi.encodePacked("outlook",Strings.toString(tokenId))));
    rand=rand % outlooks.length;
    return outlooks[rand];
  }

  function random(string memory input)internal pure returns(uint256){
    return uint256(keccak256(abi.encodePacked(input)));
  }

   function makeAnEpicNFT() public {
      require(_tokenIds.current()<50,"Only 50 NFT Can be minted");
       uint256 newItemId=_tokenIds.current();
       string memory creature=pickRandomFirstWord(newItemId);
       string memory power=pickRandomSecondWord(newItemId);
       string memory  outlook=pickRandomThirdWord(newItemId);

       string memory combinedSvg=string(abi.encodePacked(baseSvg,creature,lineCompSvg,power,lineCompSvg,outlook,svgEnding));
        
      

      

  string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                     string(abi.encodePacked("Superhuman",Strings.toString(newItemId))),
                    '", "description": "A highly acclaimed collection SuperHuman ability box.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(combinedSvg)),
                    '"}'
                )
            )
        )
    );

      string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );


       _safeMint(msg.sender,newItemId);

       _setTokenURI(newItemId, finalTokenUri);

      

       _tokenIds.increment();

 console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

 emit NewEpicNFTMinted(msg.sender, newItemId);

   }
 function getTotalNFTsMintedSoFar() public view returns(uint256){
  
  return _tokenIds.current();

 }
   
  
}