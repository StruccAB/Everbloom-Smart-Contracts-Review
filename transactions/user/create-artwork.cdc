import Everbloom from "../../contracts/Everbloom.cdc"
import ArtworkMetadata from "../../contracts/ArtworkMetadata.cdc"

transaction {
  let userRef: &Everbloom.User
  let galleryRef: &Everbloom.Gallery

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&Everbloom.User>(from: Everbloom.UserStoragePath)
            ?? panic("Could not borrow a reference to the user")

    let galleries: [UInt32] = self.userRef.getAllGalleries()
    self.galleryRef = self.userRef.borrowGallery(galleryID: galleries.removeFirst())
        ?? panic("Could not borrow a reference to the gallery")
  }

  execute {
    let creator: ArtworkMetadata.Creator = ArtworkMetadata.Creator(
      name: "John Doe",
      bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
      address: 0x01,
      externalLink: nil
    )
    let content: ArtworkMetadata.Content = ArtworkMetadata.Content(
      name: "Mona Lipa",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
      image: "https://example.com/mona-lip.png",
      thumbnail: "https://example.com/mona-lipa-thumbnai.png",
      animation: "https://example.com/mona-lipa.mp4",
      externalLink: nil
    )
    let attributes: [ArtworkMetadata.Attribute] = []

    let metadata: {String: AnyStruct} = {
      "creator": creator,
      "content": content,
      "attributes": attributes,
      "additional 1": [{"z": "3"}],
      "additional 2": {"x": "1"}
    }
    self.galleryRef.createArtwork(
      externalPostID: "external-post-id",
      metadata: metadata
    )
  }
}
