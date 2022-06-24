import Everbloom2 from "../../../contracts/Everbloom2.cdc"

// Transaction to create a new Gallery resource in User resource

transaction (name: String) {
  let userRef: &Everbloom2.User

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&Everbloom2.User>(from: Everbloom2.UserStoragePath)
        ?? panic("Could not borrow a reference to the user")
  }

  execute {
    self.userRef.createGallery(name: name)
  }
}
