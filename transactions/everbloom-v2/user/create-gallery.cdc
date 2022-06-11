import EverbloomV2 from "../../../contracts/EverbloomV2.cdc"

// Transaction to create a new Gallery resource in User resource

transaction (name: String) {
  let userRef: &EverbloomV2.User

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&EverbloomV2.User>(from: EverbloomV2.UserStoragePath)
        ?? panic("Could not borrow a reference to the user")
  }

  execute {
    self.userRef.createGallery(name: name)
  }
}
