/**
 * return arguments for create gallery transaction
 * @param {number} id
 * @return {any[]}
 */
export const getCreateGalleryArguments = (id = 1) => {
  const galleryName = `GALLERY_${id}`

  return [galleryName];
}

/**
 * return arguments for create artwork transaction
 * @param {number} galleryId
 * @param {string} creatorName
 * @param {number} id
 * @return {any[]}
 */
export const getCreateArtworkArgument = (galleryId, creatorName, id = 1) => {
  const externalPostId = `EXTERNAL_POST_${id}`
  const creator = {
    name: creatorName,
    bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
  }
  const content = {
    name: `Mona Lipa ${id}`,
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    image: `https://example.com/mona-lip-${id}.png`,
    thumbnail: `https://example.com/mona-lipa-${id}-thumbnai.png`,
    animation: `https://example.com/mona-lipa-${id}.mp4`,
  }
  const attributes = {
    "trait_1": "value_1",
    "trait_2": "value_2",
  }
  const additionalMetadata = { additionalAttribute: 'XXXXX' }

  return [galleryId, externalPostId, creator, content, attributes, additionalMetadata]
}

/**
 * return arguments for create artwork transaction for Everbloom V2
 * @param {number} galleryId
 * @param {string} creatorName
 * @param {number} id
 * @return {boolean} flag to include perks
 */
export const getCreateArtworkEverbloomv2Argument = (galleryId, creatorName, id = 1, addPerks = false) => {
  const externalPostId = `EXTERNAL_POST_${id}`
  const metadata = {
    creatorName,
    name: `test-artwork${id}`,
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    image: "https://d2st0fnq3grac2.cloudfront.net/flow-fest/tickets/holo.png",
    thumbnail: "https://d2st0fnq3grac2.cloudfront.net/flow-fest/tickets/holo-thumbnail.png",
    video: "https://d2st0fnq3grac2.cloudfront.net/flow-fest/tickets/holo-thumbnail.png",
    previewUrl: "https://everbloom.app/ticket/holo",
    creatorUrl: "https://everbloom.app",
    creatorDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
  }
  let perks = []

  if (addPerks) {
    perks = [
      {
        type: 'PERK_TYPE_1',
        title: 'PERK_1',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
        url: 'https://everbloom.app/holo/perks'
      },
      {
        type: 'PERK_TYPE_2',
        title: 'PERK_2',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      }
    ]
  }

  return [galleryId, externalPostId, metadata, perks]
}

/**
 * return arguments for create edition transaction
 * @param {number} galleryId
 * @param {number} artworkId
 * @param {number} id
 * @return {any[]}
 */
export const getCreateEditionArguments = (galleryId, artworkId, id = 1) => {
  const editionName = `EDITION_${id}`

  return [galleryId, artworkId, editionName];
}

/**
 * return arguments for mint print transaction
 * @param {number} galleryId
 * @param {number} artworkId
 * @param {number} editionId
 * @param {number} id
 * @return {any[]}
 */
export const getMintPrintArguments = (galleryId, artworkId, editionId, id = 1) => {
  const signature = `SIGNATURE_${id}`

  return [galleryId, artworkId, editionId, signature];
}

/**
 * return arguments for mint print transaction
 * @param {number} galleryId
 * @param {number} artworkId
 * @param {number} id
 * @return {boolean} flase to include signature
 */
export const getMintPrintEverbloomv2Arguments = (galleryId, artworkId, id = 1, addSignature = true) => {
  const externalPrintId = `EXTERNAL_PRINT_${id}`
  let signature;

  if (addSignature) {
    signature = `SIGNATURE_${id}`
  }
  const metadata = {};

  return [galleryId, artworkId, externalPrintId, signature, metadata];
}
