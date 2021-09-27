import Everbloom from "../../contracts/Everbloom.cdc"

// Transaction to create a new Gallery resource in User resource

transaction (name: String) {
  let userRef: &Everbloom.User

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&Everbloom.User>(from: Everbloom.UserStoragePath)
        ?? panic("Could not borrow a reference to the user")
  }

  execute {
    self.userRef.createGallery(name: name)
  }
}
