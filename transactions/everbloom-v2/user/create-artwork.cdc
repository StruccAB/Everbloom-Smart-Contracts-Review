import EverbloomV2 from "../../../contracts/EverbloomV2.cdc"
import EverbloomMetadata from "../../../contracts/EverbloomMetadata.cdc"

// Transaction to create a new Artwork resource in Gallery resource

transaction (
  galleryID: UInt32,
  externalPostID: String,
  metadata: {String: String},
  perkDatas: [EverbloomMetadata.PerkData]
  ) {
  let userRef: &EverbloomV2.User
  let galleryRef: &EverbloomV2.Gallery
  let ownerAddress: Address;

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&EverbloomV2.User>(from: EverbloomV2.UserStoragePath)
            ?? panic("Could not borrow a reference to the user")

    let galleries: [UInt32] = self.userRef.getAllGalleries()
    self.galleryRef = self.userRef.borrowGallery(galleryID: galleryID)
      ?? panic("Could not borrow a reference to the gallery")
    self.ownerAddress = acct.address
  }

  execute {
    self.galleryRef.createArtwork(
      externalPostID: externalPostID,
      perkDatas: perkDatas,
      metadata: metadata
    )
  }
}
