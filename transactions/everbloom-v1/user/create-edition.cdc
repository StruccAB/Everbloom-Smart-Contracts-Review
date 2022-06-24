import Everbloom from "../../contracts/Everbloom.cdc"

// Transaction to create a new edition in Artwork resource

transaction (galleryID: UInt32, artworkID: UInt32, name: String) {
  let galleryRef: &Everbloom.Gallery
  let artRef: &Everbloom.Artwork

  prepare(acct: AuthAccount) {
    let userRef = acct.borrow<&Everbloom.User>(from: Everbloom.UserStoragePath)
            ?? panic("Could not borrow a reference to the user")

    let galleries: [UInt32] = userRef.getAllGalleries()
    self.galleryRef = userRef.borrowGallery(galleryID: galleryID)
     ?? panic("Could not borrow a reference to the gallery")
    self.artRef = self.galleryRef.borrowArtwork(artworkID: artworkID)
     ?? panic("Could not borrow a reference to the artwork")
  }

  execute {
    self.artRef.createEdition(name: name)
  }
}
