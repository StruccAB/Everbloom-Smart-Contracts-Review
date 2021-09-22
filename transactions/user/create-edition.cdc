import Everbloom from "../../contracts/Everbloom.cdc"

transaction {
  let galleryRef: &Everbloom.Gallery
  let artRef: &Everbloom.Artwork

  prepare(acct: AuthAccount) {
    let userRef = acct.borrow<&Everbloom.User>(from: Everbloom.UserStoragePath)
        ?? panic("Could not borrow a reference to the user")

    let galleries: [UInt32] = userRef.getAllGalleries()
    self.galleryRef = userRef.borrowGallery(galleryID: galleries.removeFirst())
        ?? panic("Could not borrow a reference to the gallery")
    self.artRef = self.galleryRef.borrowArtwork(artworkID: self.galleryRef.getAllArtworks().removeFirst())
        ?? panic("Could not borrow a reference to the artwork")
  }

  execute {
    self.artRef.createEdition(name: "DEFAULT")
  }
}
