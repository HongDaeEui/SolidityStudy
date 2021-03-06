// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract TreeItems is ERC1155 {
    
    mapping(address => uint) public balances;
    mapping(address => uint) public drawcode;
     // Optional mapping for token URIs
    mapping(uint256 => string) internal tokenURIs;
    address public owner;

    uint256 public constant Baby = 0;
    uint256 public constant Iron = 1;
    uint256 public constant Bronze = 2;
    uint256 public constant SILVER = 3;
    uint256 public constant GOLD = 4;
    uint256 public constant Platinum = 5;
    uint256 public constant Diamond = 6;
    uint256 public constant Draw_Ticket = 7;
    
    
        constructor() public ERC1155("https://raw.githubusercontent.com/HongDaeEui/SolidityProject/main/nft/{id}.json") {
        owner = msg.sender; 
        
        _mint(msg.sender, Baby, 10**15, "");
        _mint(msg.sender, Iron, 10**13, "");
        _mint(msg.sender, Bronze, 10**11, "");
        _mint(msg.sender, SILVER, 10**9, "");
        _mint(msg.sender, GOLD, 10**7, "");
        _mint(msg.sender, Platinum, 10**5, "");
        _mint(msg.sender, Diamond, 10**3, "");
        
        _mint(msg.sender, Draw_Ticket, 10**18, "");
        
        

        _setTokenURI(0, "https://raw.githubusercontent.com/HongDaeEui/SolidityProject/main/nft/0000000000000000000000000000000000000000000000000000000000000000.json");
        _setTokenURI(1, "https://raw.githubusercontent.com/HongDaeEui/SolidityProject/main/nft/0000000000000000000000000000000000000000000000000000000000000001.json");
        _setTokenURI(2, "https://raw.githubusercontent.com/HongDaeEui/SolidityProject/main/nft/0000000000000000000000000000000000000000000000000000000000000002.json");
        _setTokenURI(3, "https://raw.githubusercontent.com/HongDaeEui/SolidityProject/main/nft/0000000000000000000000000000000000000000000000000000000000000003.json");
        _setTokenURI(4, "https://raw.githubusercontent.com/HongDaeEui/SolidityProject/main/nft/0000000000000000000000000000000000000000000000000000000000000004.json");
        _setTokenURI(5, "https://raw.githubusercontent.com/HongDaeEui/SolidityProject/main/nft/0000000000000000000000000000000000000000000000000000000000000005.json");
        _setTokenURI(6, "https://raw.githubusercontent.com/HongDaeEui/SolidityProject/main/nft/0000000000000000000000000000000000000000000000000000000000000006.json");
        }
    
    
        modifier onlyOwner () {
        require(msg.sender == owner);
        _;}



     function donate() public payable {
        
        balances[msg.sender] += msg.value;
        
        uint silverNumber;
        uint bronzeNumber;
        uint ironNumber;
        uint babyNumber;
        uint treeNumber; 
        
        treeNumber = msg.value/(5*(10**14));
        
       
        if(treeNumber<10) {
            _safeTransferFrom(owner, msg.sender, 0, treeNumber, "");
        }else if(treeNumber<50) {
            ironNumber = treeNumber/10;
            babyNumber = treeNumber%10;
            
            _safeTransferFrom(owner, msg.sender, 0, babyNumber, "");
            _safeTransferFrom(owner, msg.sender, 1, ironNumber, "");
        }else if(treeNumber<200) {
            bronzeNumber = treeNumber/50;
            ironNumber =  (treeNumber%50)/10;
            babyNumber = (treeNumber%50)%10;
            
             _safeTransferFrom(owner, msg.sender, 0, babyNumber, "");
              _safeTransferFrom(owner, msg.sender, 1, ironNumber, "");
               _safeTransferFrom(owner, msg.sender, 2, bronzeNumber, "");
        }else {
            silverNumber = treeNumber/200;
            bronzeNumber = (treeNumber%200)/50;
            ironNumber = (treeNumber%200)%50/10;
            babyNumber = (treeNumber%200)%50%10;
            
            _safeTransferFrom(owner, msg.sender, 0, babyNumber, "");
              _safeTransferFrom(owner, msg.sender, 1, ironNumber, "");
               _safeTransferFrom(owner, msg.sender, 2, bronzeNumber, "");
               _safeTransferFrom(owner, msg.sender, 3, silverNumber, "");
        }
        
        
        if( balances[msg.sender] % (5*(10**17)) == 0) {
            
            uint drawNumber;
            drawNumber = balances[msg.sender]/(5*(10**17)) - drawcode[msg.sender];
             _safeTransferFrom(owner, msg.sender, 7, drawNumber, "");
             drawcode[msg.sender] += drawNumber;
        }
     }
     
     
     
       /**
       * @param _tokenId uint256 ID of the token to set its URI
       * @param _uri string URI to assign
       */
      function _setTokenURI(uint256 _tokenId, string memory _uri) internal {
        tokenURIs[_tokenId] = _uri;
      }

     
        
      function merge_cards(uint fromID, uint toID) public  {
        _safeTransferFrom(msg.sender, owner, fromID, 10, "");
        _safeTransferFrom(owner, msg.sender, toID, 1, "");
     }


    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }


    function donation_balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
}

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public {
        _mint( account, id, amount, data);
    }
    
    function burn(address account, uint256 id, uint256 amount) public {
         _burn( account, id, amount );
    }
    
     receive() external payable {}

}
