import Everbloom2 from "../../../contracts/Everbloom2.cdc"
import EverbloomMetadata from "../../../contracts/EverbloomMetadata.cdc"

// Transaction to create a new Artwork resource in Gallery resource

transaction (
  galleryID: UInt32,
  externalPostID: String,
  argMetadata: {String: String},
  perks: [{String: String}]
  ) {
  let userRef: &Everbloom2.User
  let galleryRef: &Everbloom2.Gallery
  let ownerAddress: Address;

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&Everbloom2.User>(from: Everbloom2.UserStoragePath)
            ?? panic("Could not borrow a reference to the user")
    self.galleryRef = self.userRef.borrowGallery(galleryID: galleryID)
      ?? panic("Could not borrow a reference to the gallery")
    self.ownerAddress = acct.address
  }

  execute {
    let metadata = argMetadata;
    let perkDatas: [EverbloomMetadata.PerkData] = []

    for perk in perks {
        perkDatas.append(EverbloomMetadata.PerkData(
            type: perk["type"] ?? panic("Perk type is required"),
            title: perk["title"] ?? panic("Perk title is required"),
            description: perk["description"] ?? panic("Perk description is required"),
            url: perk["url"],
        ))
    }

    metadata.insert(key: "creatorAddress", self.ownerAddress.toString())
    self.galleryRef.createArtwork(
      externalPostID: externalPostID,
      perkDatas: perkDatas,
      metadata: metadata,
      // buildingBlockIds functionality will be implemented once Building block contract is ready
      buildingBlockIds: []
    )
  }
}
