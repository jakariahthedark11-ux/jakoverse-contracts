pragma solidity ^0.8.24;
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * JAKOVERSE Lands – Pack 1
 *
 * Minimal canonical ERC-721 collection for:
 *   JAKOVA_NET::CRYPTO_LANDS_PACK1_V1
 *
 * - Fixed max supply (e.g. 500 plots)
 * - Owner-only mint (we control distribution logic off-chain or via scripts)
 * - Simple baseURI for metadata hosting
 */
contract JakoverseLands is ERC721Enumerable, Ownable {
    uint256 public immutable maxSupply;
    uint256 private _nextTokenId = 1;

    string private _baseTokenURI;

    event BaseURIUpdated(string newBaseURI);
    event LandMinted(address indexed to, uint256 indexed tokenId);

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_,
        string memory baseURI_
    ) ERC721(name_, symbol_) Ownable(msg.sender) {
        require(maxSupply_ > 0, "Max supply must be > 0");
        maxSupply = maxSupply_;
        _baseTokenURI = baseURI_;
    }

    // ------------------------------------------------------------
    //   Minting – controlled by contract owner
    // ------------------------------------------------------------

    /**
     * @dev Owner-only mint. Can mint 1 or more plots in one tx.
     */
    function ownerMint(address to, uint256 quantity) external onlyOwner {
        require(quantity > 0, "Quantity must be > 0");
        require(
            totalSupply() + quantity <= maxSupply,
            "Mint would exceed max supply"
        );

        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = _nextTokenId++;
            _safeMint(to, tokenId);
            emit LandMinted(to, tokenId);
        }
    }

    // ------------------------------------------------------------
    //   Metadata handling
    // ------------------------------------------------------------

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
        emit BaseURIUpdated(newBaseURI);
    }

    // ------------------------------------------------------------
    //   Admin helpers
    // ------------------------------------------------------------

    function remainingSupply() external view returns (uint256) {
        return maxSupply - totalSupply();
    }
}
