import Everbloom from "../../contracts/Everbloom.cdc"

transaction {
  let collectionRef: &Everbloom.Collection
  let userRef: &Everbloom.User

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&Everbloom.User>(from: /storage/EverbloomUser)
        ?? panic("Could not borrow a reference to the user")
    self.collectionRef = acct.borrow<&Everbloom.Collection>(from: /storage/EverbloomCollection)
        ?? panic("Could not borrow a reference to the collection")
  }

  execute {
    let galleryID: UInt32 = self.userRef.getAllGalleries().removeFirst()
    let galleryRef = self.userRef.borrowGallery(galleryID: galleryID)
        ?? panic("Could not borrow a Gallery")
    let artworkID: UInt32 = galleryRef.getAllArtworks().removeFirst()
    let artworkRef = galleryRef.borrowArtwork(artworkID: artworkID)
        ?? panic("Could not borrow a reference to the artwork")
    let editionID = artworkRef.getAllEditions().removeFirst()

    let newPrint <- self.userRef.mintPrint(
      galleryID: galleryID,
      artworkID: artworkID,
      editionID: editionID,
      signature: "https://example.com/mona-lipa/signature-1.png"
    )
    self.collectionRef.deposit(token: <- newPrint)
  }
}

