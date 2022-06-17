import path from "path";
import {
  emulator,
  init,
  shallResolve,
  shallPass,
  shallRevert,
} from "flow-js-testing";

import {
  deployEverbloom,
  getPrintCount,
  getEverblooomSupply,
  setupCollectionOnAccount,
  createUser,
  getGalleryCount,
  createGallery,
  createArtwork,
  getLastGalleryId,
  getArtworkCount,
  getLastArtworkId,
  createEdition,
  getEditionCount,
  getLastEditionId,
  mintPrint,
  createMinter,
  addUserMintingCapability, transferPrint, getLastPrintId
} from "../../src/everbloom-v1";
import {
  getEverbloomAdminAddress,
  getUserAliceAddress,
  getUserBobAddress,
} from "../../src/common";
import {
  getCreateArtworkArgument,
  getCreateEditionArguments,
  getCreateGalleryArguments,
  getMintPrintArguments
} from "../../src/mock-data";

// Increase timeout if your tests failing due to timeout
jest.setTimeout(10000);

describe("everbloom V1", ()=>{
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
    await deployEverbloom();
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
    const args = getCreateArtworkArgument(galleryId, "Bob")

    await shallPass(createArtwork(UserBob, args))

    await shallResolve(async () => {
      const artworkCount = await getArtworkCount(UserBob, galleryId)
      expect(artworkCount).toBe(1);
    });
  });

  it("shall be able to create a new Edition", async () => {
    const UserBob = await getUserBobAddress();
    const galleryId = await getLastGalleryId(UserBob)
    const artworkId = await getLastArtworkId(UserBob, galleryId)

    await shallPass(createEdition(UserBob, getCreateEditionArguments(galleryId, artworkId)))

    await shallResolve(async () => {
      const editionCount = await getEditionCount(UserBob, galleryId, artworkId)
      expect(editionCount).toBe(1);
    });
  });

  it("shall not be able to mint a print", async () => {
    const UserBob = await getUserBobAddress();
    const galleryId = await getLastGalleryId(UserBob)
    const artworkId = await getLastArtworkId(UserBob, galleryId)
    const editionId = await getLastEditionId(UserBob, galleryId, artworkId)

    await shallRevert(mintPrint(UserBob, getMintPrintArguments(galleryId, artworkId, editionId)))
  });

  it("Admin shall be able to share minting capability", async () => {
    const UserBob = await getUserBobAddress();
    const Admin = await getEverbloomAdminAddress();

    await shallPass(addUserMintingCapability(Admin, UserBob))
  });

  it("shall be able to mint a print", async () => {
    const UserBob = await getUserBobAddress();
    const galleryId = await getLastGalleryId(UserBob)
    const artworkId = await getLastArtworkId(UserBob, galleryId)
    const editionId = await getLastEditionId(UserBob, galleryId, artworkId)

    await shallPass(mintPrint(UserBob, getMintPrintArguments(galleryId, artworkId, editionId)))

    await shallResolve(async () => {
      const itemCount = await getPrintCount(UserBob);
      expect(itemCount).toBe(1);
    });
  });

  it("shall be able to transfer a print", async () => {
    const UserBob = await getUserBobAddress();
    const UserAlice = await getUserAliceAddress();
    const bobIPrintCount = await getPrintCount(UserBob);
    const galleryId = await getLastGalleryId(UserBob)
    const artworkId = await getLastArtworkId(UserBob, galleryId)
    const editionId = await getLastEditionId(UserBob, galleryId, artworkId)

    await shallPass(mintPrint(UserBob, getMintPrintArguments(galleryId, artworkId, editionId)))
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
