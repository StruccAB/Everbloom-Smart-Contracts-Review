import {
  deployContractByName,
  executeScript,
  sendTransaction,
  mintFlow,
} from "flow-js-testing";
import { getEverbloomAdminAddress } from "./common";

/*
 * Deploys Everbloom contract to EverbloomAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployEverbloom = async () => {
  const EverbloomAdmin = await getEverbloomAdminAddress();
  await mintFlow(EverbloomAdmin, "10.0");

  await deployContractByName({ to: EverbloomAdmin, name: "NonFungibleToken", update: true });
  await deployContractByName({ to: EverbloomAdmin, name: "ArtworkMetadata" });
  const addressMap = { NonFungibleToken: EverbloomAdmin, ArtworkMetadata: EverbloomAdmin };

  return deployContractByName({ to: EverbloomAdmin, name: "Everbloom", addressMap });
};

/*
 * Setups Everbloom Collection on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const setupCollectionOnAccount = async (account) => {
  const name = "everbloom-v1/user/setup-collection";

  const signers = [account];

  return sendTransaction({ name, signers });
};

/*
 * Create and setup Minter resource on admin account
 * @param {string} account - account address
 * @returns {Promise<*>}
 * */
export const createMinter = async (account) => {
  const name = "everbloom-v1/admin/create-minter";
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
  const name = "everbloom-v1/admin/add-minting-capability";
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
  const name = "everbloom-v1/user/create-user";
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
  const name = "everbloom-v1/user/create-gallery";
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
  const name = "everbloom-v1/user/create-artwork";
  const signers = [account];

  return sendTransaction({ name, signers, args });
};

/*
 * Create edition in a Artwork resource
 * @param {string} account - account address
 * @param {any[]} args - argument for the create edition transaction
 * @returns {Promise<*>}
 * */
export const createEdition = async (account, args) => {
  const name = "everbloom-v1/user/create-edition";
  const signers = [account];

  return sendTransaction({ name, signers, args });
};

/*
 * mint Print NFT under an edition in an Artwork resource
 * @param {string} account - account address
 * @param {any[]} args - argument for the mint print transaction
 * @returns {Promise<*>}
 * */
export const mintPrint = async (account, args) => {
  const name = "everbloom-v1/user/mint-print";
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
  const name = "everbloom-v1/user/transfer-print";
  const signers = [account];

  return sendTransaction({ name, signers, args });
};

/*
 * Returns Everblooom supply.
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64} - number of NFT minted so far
 * */
export const getEverblooomSupply = async () => {
  const name = "everbloom-v1/get-total-supply";

  return executeScript({ name });
};

/*
 * Returns the number of Prints in an account's collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getPrintCount = async (account) => {
  const name = "everbloom-v1/get-collection-length";
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
  const name = "everbloom-v1/get-gallery-length";
  const args = [account];

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
  const name = "everbloom-v1/get-artwork-length";
  const args = [account, galleryId];

  return executeScript({ name, args });
};

/*
 * Returns the number of Editions in an Artwork
 * @param {string} account - account address
 * @param {number} galleryId - id of the gallery
 * @param {number} artworkId - id of the artwork
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getEditionCount = async (account, galleryId, artworkId) => {
  const name = "everbloom-v1/get-edition-length";
  const args = [account, galleryId, artworkId];

  return executeScript({ name, args });
};

/*
 * Returns the last gallery of user galleries.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getLastGalleryId = async (account) => {
  const name = "everbloom-v1/get-last-gallery-of-user";
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
  const name = "everbloom-v1/get-last-artwork-of-gallery";
  const args = [account, galleryId];

  return executeScript({ name, args });
};

/*
 * Returns the last edition id of Artwork.
 * @param {string} account - account address
 * @param {number} galleryId - id of the gallery
 * @param {number} artworkId - id of the artwork
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getLastEditionId = async (account, galleryId, artworkId) => {
  const name = "everbloom-v1/get-last-edition-of-artwork";
  const args = [account, galleryId, artworkId];

  return executeScript({ name, args });
};

/*
 * Returns the last print id of Gallery.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getLastPrintId = async (account) => {
  const name = "everbloom-v1/get-last-print-of-gallery";
  const args = [account];

  return executeScript({ name, args });
};

