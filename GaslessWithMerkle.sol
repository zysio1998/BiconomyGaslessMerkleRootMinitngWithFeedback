//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract GaslessWithMerkle is ERC721Enumerable, ERC2771Context{
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIds;

    uint256 public maxSupply = 1000;    
    uint256 public maxPerWallet = 1;     
    address public owner;
    string public baseURI;
    string public baseExtension = ".json";  
    bool public _isActive = false;        

    bytes32 private merkleRoot;      

    constructor(
        address trustedForwarder,
        string memory _initBaseURI        
    ) 
    ERC721("Gasless Testing", "GAS") 
    ERC2771Context(trustedForwarder)  
    {
        owner = msg.sender;        
        setBaseURI(_initBaseURI);        
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }    
  
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }   

    function setMerklRoot(bytes32 _merklroot) external onlyOwner{
        merkleRoot = _merklroot;
    } 

    function getMerkelRoot() external view returns(bytes32){
        return merkleRoot;
    }    

    function setPublicActive(bool isActive) external onlyOwner {
        _isActive = isActive;
    }    

    function setMaxSupply(uint256 _newmaxSupply) public onlyOwner {
        maxSupply = _newmaxSupply;
    }

    function setPerWalletAllowed(uint256 _newmaxperWallet) public onlyOwner {
        maxPerWallet = _newmaxperWallet;
    }

    function mintNFT(bytes32[] calldata _merkleProof) public  {
        uint256 totalMinted = _tokenIds.current();
        require(_isActive, "Sale has not begun yet");
        require(totalMinted < maxSupply, "Not enough NFTs left!");
        require(balanceOf(_msgSender()) < maxPerWallet, "Cannot mint more than allowed");        
        bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
        require(MerkleProof.verify(_merkleProof, merkleRoot, leaf),"Invalid Merkle Proof.");
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();        
        _safeMint(_msgSender(), tokenId);        
    }

    function tokenURI(uint256 tokenId) public view virtual override returns(string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
    }

    function _msgSender() internal view override(Context, ERC2771Context) returns (address sender) {
        sender = ERC2771Context._msgSender();
    }
   
    function _msgData() internal view override(Context, ERC2771Context) returns (bytes calldata){
        return ERC2771Context._msgData();
    }
     
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}