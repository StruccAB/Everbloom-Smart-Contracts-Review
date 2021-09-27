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
