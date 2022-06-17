import {
  deployContractByName,
  executeScript,
  sendTransaction,
  mintFlow,
} from "flow-js-testing";
import { getEverbloomAdminAddress } from "./common";

/*
 * Deploys EverbloomV2 contract to EverbloomAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployEverbloomV2 = async () => {
  const EverbloomAdmin = await getEverbloomAdminAddress();
  await mintFlow(EverbloomAdmin, "10.0");

  await deployContractByName({ to: EverbloomAdmin, name: "NonFungibleToken", update: true });
  await deployContractByName({ to: EverbloomAdmin, name: "FungibleToken" });
  let addressMap = {
    NonFungibleToken: EverbloomAdmin,
    FungibleToken: EverbloomAdmin,

  }
  await deployContractByName({ to: EverbloomAdmin, name: "MetadataViews", addressMap });
  await deployContractByName({ to: EverbloomAdmin, name: "EverbloomMetadata", addressMap: { MetadataViews: EverbloomAdmin } });
  addressMap = {
    ...addressMap,
    EverbloomMetadata: EverbloomAdmin,
    MetadataViews: EverbloomAdmin,
  };

  return deployContractByName({ to: EverbloomAdmin, name: "EverbloomV2", addressMap });
};

/*
 * Setups Everbloom Collection on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const setupCollectionOnAccount = async (account) => {
  const name = "everbloom-v2/user/setup-collection";

  const signers = [account];

  return sendTransaction({ name, signers });
};

/*
 * Create and setup Minter resource on admin account
 * @param {string} account - account address
 * @returns {Promise<*>}
 * */
export const createMinter = async (account) => {
  const name = "everbloom-v2/admin/create-minter";
  const signers = [account];

  return sendTransaction({ name, signers });
};

/*
 * share private minter capability with user
 * @param {string} account - account address
 * @param {string} userAddress - User address
 * @returns {Promise<*>}
 * */
export const addUserMintingCapability = async (account, userAddress) => {
  const name = "everbloom-v2/admin/add-minting-capability";
  const signers = [account];
  const args = [userAddress]

  return sendTransaction({ name, signers, args });
};

/*
 * Create and setup User resource on account then expose public capability
 * @param {string} account - account address
 * @returns {Promise<*>}
 * */
export const createUser = async (account) => {
  const name = "everbloom-v2/user/create-user";
  const signers = [account];

  return sendTransaction({ name, signers });
};

/*
 * Create Gallery resource in User resource
 * @param {string} account - account address
 * @param {any[]} args - argument for the create gallery transaction
 * @returns {Promise<*>}
 * */
export const createGallery = async (account, args) => {
  const name = "everbloom-v2/user/create-gallery";
  const signers = [account];

  return sendTransaction({ name, signers, args });
};

/*
 * Create Artwork resource in Gallery resource
 * @param {string} account - account address
 * @param {any[]} args - argument for the create artwork transaction
 * @returns {Promise<*>}
 * */
export const createArtwork = async (account, args) => {
  const name = "everbloom-v2/user/create-artwork";
  const signers = [account];

  return sendTransaction({ name, signers, args });
};

/*
 * mint Print NFT in an Artwork resource
 * @param {string} account - account address
 * @param {any[]} args - argument for the mint print transaction
 * @returns {Promise<*>}
 * */
export const mintPrint = async (account, args) => {
  const name = "everbloom-v2/user/mint-print";
  const signers = [account];

  return sendTransaction({ name, signers, args });
};

/*
 * invalidate a perk
 * @param {string} account - account address
 * @param {any[]} args - argument for the mint print transaction
 * @returns {Promise<*>}
 * */
export const disablePerk = async (account, args) => {
  const name = "everbloom-v2/admin/disable-perk";
  const signers = [account];

  return sendTransaction({ name, signers, args });
};

/*
 * transfer print to another user
 * @param {string} account - account address
 * @param {any[]} args - argument for the mint print transaction
 * @returns {Promise<*>}
 * */
export const transferPrint = async (account, args) => {
  const name = "everbloom-v2/user/transfer-print";
  const signers = [account];

  return sendTransaction({ name, signers, args });
};

/*
 * Returns Everblooom supply.
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64} - number of NFT minted so far
 * */
export const getEverblooomSupply = async () => {
  const name = "everbloom-v2/get-total-supply";

  return executeScript({ name });
};

/*
 * Returns the number of Prints in an account's collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getPrintCount = async (account) => {
  const name = "everbloom-v2/get-collection-length";
  const args = [account];

  return executeScript({ name, args });
};

/*
 * Returns the number of Galleries in an account's collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getGalleryCount = async (account) => {
  const name = "everbloom-v2/get-gallery-length";
  const args = [account];

  return executeScript({ name, args });
};

/*
 * Returns the Artworks stored on Contract level
 * @param {number} artworkId - id of the artwork
 * @throws Will throw an error if execution will be halted
 * @returns {Object}
 * */
export const getArtwork = async (artworkId) => {
  const name = "everbloom-v2/get-artwork";
  const args = [artworkId];

  return executeScript({ name, args });
};

/*
 * Returns the id of the arwork in the contract using external post id
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getArtworkId = async (externalPostId) => {
  const name = "everbloom-v2/get-artwork-id-by-post-id";
  const args = [externalPostId];

  return executeScript({ name, args });
};

/*
 * Returns the number of Artworks in a Gallery
 * @param {string} account - account address
 * @param {number} galleryId - id of the gallery
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getGalleryArtworkCount = async (account, galleryId) => {
  const name = "everbloom-v2/get-gallery-artwork-length";
  const args = [account, galleryId];

  return executeScript({ name, args });
};

/*
 * Returns the number of Artworks in a Gallery
 * @param {string} account - account address
 * @param {number} galleryId - id of the gallery
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getArtworkCount = async (account, galleryId) => {
  const name = "everbloom-v2/get-artwork-length";
  const args = [account, galleryId];

  return executeScript({ name, args });
};

/*
 * Returns the last gallery of user galleries.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getLastGalleryId = async (account) => {
  const name = "everbloom-v2/get-last-gallery-of-user";
  const args = [account];

  return executeScript({ name, args });
};

/*
 * Returns the last artwork id of gallery.
 * @param {string} account - account address
 * @param {number} galleryId - id of the gallery
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getLastArtworkId = async (account, galleryId) => {
  const name = "everbloom-v2/get-last-artwork-of-gallery";
  const args = [account, galleryId];

  return executeScript({ name, args });
};

/*
 * Returns the last print id of Gallery.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getLastPrintId = async (account) => {
  const name = "everbloom-v2/get-last-print-of-gallery";
  const args = [account];

  return executeScript({ name, args });
};

/*
 * Returns the MetadataViews.Display object iof the NFT metadata
 * @param {string} account - account address
 * @param {number} printId - id of the print
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getNftMetadata = async (account, printId) => {
  const name = "everbloom-v2/get-nft-metadata";
  const args = [account, printId];

  return executeScript({ name, args });
};

/*
 * Returns the EverbloomMetadata.EverbloomMetadataView object iof the NFT metadata
 * @param {string} account - account address
 * @param {number} printId - id of the print
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getPrintMetadata = async (account, printId) => {
  const name = "everbloom-v2/get-print-metadata";
  const args = [account, printId];

  return executeScript({ name, args });
};

/*
 * Returns the EverbloomMetadata.EverbloomMetadataView object iof the NFT metadata
 * @param {string} account - account address
 * @param {number} printId - id of the print
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getNftPerksMetadata = async (account, printId) => {
  const name = "everbloom-v2/get-nft-perks";
  const args = [account, printId];

  return executeScript({ name, args });
};

