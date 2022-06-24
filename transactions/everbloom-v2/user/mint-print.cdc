import Everbloom2 from "../../../contracts/Everbloom2.cdc"

// Transaction to mint a Print in a edition and store it in user Collection resource

transaction (
    galleryID: UInt32,
    artworkID: UInt32,
    externalPrintID: String,
    signature: String,
    metadata: {String: String}
) {
  let collectionRef: &Everbloom2.Collection
  let userRef: &Everbloom2.User

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&Everbloom2.User>(from: Everbloom2.UserStoragePath)
        ?? panic("Could not borrow a reference to the user")
    self.collectionRef = acct.borrow<&Everbloom2.Collection>(from: Everbloom2.CollectionStoragePath)
        ?? panic("Could not borrow a reference to the collection")
  }

  execute {
    let newPrint <- self.userRef.mintPrint(
      galleryID: galleryID,
      artworkID: artworkID,
      externalPrintID: externalPrintID,
      signature: signature,
      metadata: metadata,
      royalties: []
    )
    self.collectionRef.deposit(token: <- newPrint)
  }
}
