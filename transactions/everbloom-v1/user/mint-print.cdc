import Everbloom from "../../contracts/Everbloom.cdc"

// Transaction to mint a Print in a edition and store it in user Collection resource

transaction (galleryID: UInt32, artworkID: UInt32, editionID: UInt32, signature: String) {
  let collectionRef: &Everbloom.Collection
  let userRef: &Everbloom.User

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&Everbloom.User>(from: Everbloom.UserStoragePath)
        ?? panic("Could not borrow a reference to the user")
    self.collectionRef = acct.borrow<&Everbloom.Collection>(from: Everbloom.CollectionStoragePath)
        ?? panic("Could not borrow a reference to the collection")
  }

  execute {
    let newPrint <- self.userRef.mintPrint(
      galleryID: galleryID,
      artworkID: artworkID,
      editionID: editionID,
      signature: signature
    )
    self.collectionRef.deposit(token: <- newPrint)
  }
}
