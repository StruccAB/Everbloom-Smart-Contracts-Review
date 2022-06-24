import Everbloom from "../../contracts/Everbloom.cdc"
import ArtworkMetadata from "../../contracts/ArtworkMetadata.cdc"

// Transaction to create a new Artwork resource in Gallery resource

transaction (
  galleryID: UInt32,
  externalPostID: String,
  creator: {String: String},
  content: {String: String},
  attributes: {String: String},
  additionalMetadata: {String: String}
  ) {
  let userRef: &Everbloom.User
  let galleryRef: &Everbloom.Gallery
  let ownerAddress: Address;

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&Everbloom.User>(from: Everbloom.UserStoragePath)
            ?? panic("Could not borrow a reference to the user")

    let galleries: [UInt32] = self.userRef.getAllGalleries()
    self.galleryRef = self.userRef.borrowGallery(galleryID: galleryID)
      ?? panic("Could not borrow a reference to the gallery")
    self.ownerAddress = acct.address
  }

  execute {
    var metadata: {String: AnyStruct} = {}
    let creatorStructData = ArtworkMetadata.Creator(
      name: creator["name"] ?? panic("creator name is required"),
      bio: creator["bio"] ?? panic("creator bio is required"),
      address: self.ownerAddress,
      externalLink: creator["externalLink"] as String?
    )
    let contentStructData: ArtworkMetadata.Content = ArtworkMetadata.Content(
      name: content["name"] ?? panic("content name is required"),
      description: content["description"] ?? panic("content description is required"),
      image: content["image"] ?? panic("content image is required"),
      thumbnail: content["thumbnail"] ?? panic("content thumbnail is required"),
      animation: content["animation"] as String?,
      externalLink: content["externalLink"] as String?
    )
    let attributeStructArray: [ArtworkMetadata.Attribute] = []

    for traitType in attributes.keys {
      attributeStructArray.append(ArtworkMetadata.Attribute(
        traitType: traitType,
        value: attributes[traitType]  ?? panic("value is missing in attributes")
      ))
    }

    for key in additionalMetadata.keys {
      let value = additionalMetadata[key]  ?? panic("Invalid additional attribute value.")
      metadata.insert(key: key, value)
    }

    metadata.insert(key: "creator", creatorStructData)
    metadata.insert(key: "content", contentStructData)
    metadata.insert(key: "attributes", attributeStructArray)

    log (metadata)
    self.galleryRef.createArtwork(
      externalPostID: externalPostID,
      metadata: metadata
    )
  }
}
