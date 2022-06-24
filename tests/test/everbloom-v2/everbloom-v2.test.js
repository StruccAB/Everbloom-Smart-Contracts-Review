import path from "path";
import {
  emulator,
  init,
  shallResolve,
  shallPass,
  shallRevert,
} from "flow-js-testing";

import {
  deployEverbloom2,
  getPrintCount,
  getEverblooomSupply,
  setupCollectionOnAccount,
  createUser,
  getGalleryCount,
  createGallery,
  createArtwork,
  getLastGalleryId,
  getGalleryArtworkCount,
  getLastArtworkId,
  getArtwork,
  getArtworkIdByExternalPostId,
  getNftIdByExternalPrintId,
  mintPrint,
  getNftMetadata,
  getPrintMetadata,
  getNftPerksMetadata,
  createMinter,
  addUserMintingCapability,
  transferPrint,
  getLastPrintId,
  disablePerk
} from "../../src/everbloom-v2";
import {
  getEverbloomAdminAddress,
  getUserAliceAddress,
  getUserBobAddress,
} from "../../src/common";
import {
  getCreateArtworkEverbloom2Argument,
  getCreateGalleryArguments,
  getMintPrintArguments, getMintPrintEverbloom2Arguments
} from "../../src/mock-data";

// Increase timeout if your tests failing due to timeout
jest.setTimeout(10000);

describe("everbloom V2", ()=>{
  beforeAll(async () => {
    const basePath = path.resolve(__dirname, "../../../../Everbloom-Smart-Contracts-Review");
    // You can specify different port to parallelize execution of describe blocks
    const port = 8080;
    // Setting logging flag to true will pipe emulator output to console
    const logging = false;

    await init(basePath, { port, logging });
    return emulator.start(port);
  });

 // Stop emulator, so it could be restarted
  afterAll(async () => {
    return emulator.stop();
  });

  it("shall deploy Everbloom contract", async () => {
    await deployEverbloom2();
  });

  it("Admin shall be able to create a new Minter", async () => {
    const Admin = await getEverbloomAdminAddress();

    await shallPass(createMinter(Admin))
  });

  it("User shall be not able to create a new Minter", async () => {
    const UserBob = await getUserBobAddress();

    await shallRevert(createMinter(UserBob))
  });

  it("supply shall be 0 after contract is deployed", async () => {
    await shallResolve(async () => {
      const supply = await getEverblooomSupply();
      expect(supply).toBe(0);
    });
  });

  it("shall be able to create a new empty NFT Collection", async () => {
    const UserBob = await getUserBobAddress();

    await shallPass(setupCollectionOnAccount(UserBob));

    // shall be able te read Alice collection and ensure it's empty
    await shallResolve(async () => {
      const itemCount = await getPrintCount(UserBob);
      expect(itemCount).toBe(0);
    });
  });

  it("shall be able to create a new User", async () => {
    const UserBob = await getUserBobAddress();

    await shallPass(createUser(UserBob));

    await shallResolve(async () => {
      const galleryCount = await getGalleryCount(UserBob);
      expect(galleryCount).toBe(0);
    });
  });

  it("shall not be able to create a new Gallery", async () => {
    const UserBob = await getUserBobAddress();

    await shallRevert(createGallery(UserBob, getCreateGalleryArguments()))

    await shallResolve(async () => {
      const galleryCount = await getGalleryCount(UserBob);
      expect(galleryCount).toBe(0);
    });
  });

  it("Admin shall be able to share minting capability", async () => {
    const UserBob = await getUserBobAddress();
    const Admin = await getEverbloomAdminAddress();

    await shallPass(addUserMintingCapability(Admin, UserBob))
  });

  it("shall be able to create a new Gallery", async () => {
    const UserBob = await getUserBobAddress();

    await shallPass(createGallery(UserBob, getCreateGalleryArguments()))

    await shallResolve(async () => {
      const galleryCount = await getGalleryCount(UserBob);
      expect(galleryCount).toBe(1);
    });
  });

  it("shall be able to create a new Artwork", async () => {
    const UserBob = await getUserBobAddress();
    const galleryId = await getLastGalleryId(UserBob)
    const args = getCreateArtworkEverbloom2Argument(galleryId, "Bob", 1, true)

    await shallPass(createArtwork(UserBob, args))

    await shallResolve(async () => {
      const argMetadata = args[2];
      const externalPostId = args[1];
      const artworkCount = await getGalleryArtworkCount(UserBob, galleryId)
      const artworkIdUsingExternalPostId = await getArtworkIdByExternalPostId(externalPostId);
      const artworkId = await getLastArtworkId(UserBob, galleryId);
      const artwork = await getArtwork(artworkId);

      expect(artworkCount).toBe(1);
      expect(artworkIdUsingExternalPostId).toBe(artworkId);
      expect({
        name: artwork.metadata.name,
        description: artwork.metadata.description,
        creatorAddress: artwork.metadata.creatorAddress,
        externalPostId: artwork.externalPostID,
      }).toMatchObject({
        name: argMetadata.name,
        description: argMetadata.description,
        creatorAddress: UserBob,
        externalPostId: externalPostId,
      });
    });
  });

  it("shall be able to mint a print", async () => {
    const UserBob = await getUserBobAddress();
    const galleryId = await getLastGalleryId(UserBob)
    const artworkId = await getLastArtworkId(UserBob, galleryId)
    const args = getMintPrintEverbloom2Arguments(galleryId, artworkId);

    await shallPass(mintPrint(UserBob, args))

    await shallResolve(async () => {
      const artwork = await getArtwork(artworkId);
      const itemCount = await getPrintCount(UserBob);
      const printId = await getNftIdByExternalPrintId(args[2]);
      const nftMetadata = await getNftMetadata(UserBob, printId);
      const printMetadata = await getPrintMetadata(UserBob, printId);

      expect(itemCount).toBe(1);
      expect(printMetadata.serialNumber).toBe(1);
      expect(printMetadata.totalPrintMinted).toBe(1);
      expect({
        name: nftMetadata.name,
        description: nftMetadata.description,
        thumbnail: nftMetadata.thumbnail.url,
      }).toMatchObject({
        name: artwork.metadata.name,
        description: artwork.metadata.description,
        thumbnail: artwork.metadata.thumbnail
      });
      expect({
        name: printMetadata.name,
        description: printMetadata.description,
        thumbnail: printMetadata.thumbnail.url,
        image: printMetadata.image.url,
        video: printMetadata.video.url,
        previewUrl: printMetadata.previewUrl,
        creatorName: printMetadata.creatorName,
        creatorUrl: printMetadata.creatorUrl,
        creatorDescription: printMetadata.creatorDescription,
        creatorAddress: printMetadata.creatorAddress,
        signature: printMetadata.signature.url,
        externalPostId: printMetadata.externalPostId,
        externalPrintId: printMetadata.externalPrintId,
      }).toMatchObject({
        name: artwork.metadata.name,
        description: artwork.metadata.description,
        thumbnail: artwork.metadata.thumbnail,
        image: artwork.metadata.image,
        video: artwork.metadata.video,
        previewUrl: artwork.metadata.previewUrl,
        creatorUrl: artwork.metadata.creatorUrl,
        creatorName: artwork.metadata.creatorName,
        creatorDescription: artwork.metadata.creatorDescription,
        creatorAddress: artwork.metadata.creatorAddress,
        signature: args[3],
        externalPostId: artwork.externalPostID,
        externalPrintId: args[2],
      });
    });
  });

  it("Admin shall be shall be able to disable a perk", async () => {
    const UserBob = await getUserBobAddress();
    const Admin = await getEverbloomAdminAddress();
    let perkId, printId;

    await shallResolve(async () => {
      printId = await getLastPrintId(UserBob);
      const perkMetadata = await getNftPerksMetadata(UserBob, printId);
      const { perks } = perkMetadata;

      expect(perks.length).toBe(2);
      expect(perks.every((perk) => perk.isValid)).toBe(true);
      perkId = perks[0].perkID;
    });

    await shallPass(disablePerk(Admin, [perkId]))

    await shallResolve(async () => {
      const perkMetadata = await getNftPerksMetadata(UserBob, printId);
      const { perks } = perkMetadata;

      expect(perks.length).toBe(2);
      expect(perks.find((perk) => perk.perkID === perkId).isValid).toBe(false);
    });
  });

  it("shall be able to transfer a print", async () => {
    const UserBob = await getUserBobAddress();
    const UserAlice = await getUserAliceAddress();
    const bobIPrintCount = await getPrintCount(UserBob);
    const galleryId = await getLastGalleryId(UserBob)
    const artworkId = await getLastArtworkId(UserBob, galleryId)

    await shallPass(mintPrint(UserBob, getMintPrintEverbloom2Arguments(galleryId, artworkId)))
    const printId = await getLastPrintId(UserBob)

    await shallPass(setupCollectionOnAccount(UserAlice));
    await shallPass(transferPrint(UserBob, [UserAlice, printId]))

    await shallResolve(async () => {
      const newBobPrintCount = await getPrintCount(UserBob);
      const alicePrintCount = await getPrintCount(UserBob);

      expect(newBobPrintCount).toBe(bobIPrintCount);
      expect(alicePrintCount).toBe(1);
    });
  });
})
