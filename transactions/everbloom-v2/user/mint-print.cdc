import EverbloomV2 from "../../../contracts/EverbloomV2.cdc"

// Transaction to mint a Print in a edition and store it in user Collection resource

transaction (
    galleryID: UInt32,
    artworkID: UInt32,
    signature: String,
    metadata: {String: String}
) {
  let collectionRef: &EverbloomV2.Collection
  let userRef: &EverbloomV2.User

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&EverbloomV2.User>(from: EverbloomV2.UserStoragePath)
        ?? panic("Could not borrow a reference to the user")
    self.collectionRef = acct.borrow<&EverbloomV2.Collection>(from: EverbloomV2.CollectionStoragePath)
        ?? panic("Could not borrow a reference to the collection")
  }

  execute {
    let newPrint <- self.userRef.mintPrint(
      galleryID: galleryID,
      artworkID: artworkID,
      signature: signature,
      metadata: metadata,
      royalties: []
    )
    self.collectionRef.deposit(token: <- newPrint)
  }
}
