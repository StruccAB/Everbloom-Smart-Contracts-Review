import Everbloom from "../../contracts/Everbloom.cdc"

transaction {
  let userRef: &Everbloom.User

  prepare(acct: AuthAccount) {
    self.userRef = acct.borrow<&Everbloom.User>(from: Everbloom.UserStoragePath)
            ?? panic("Could not borrow a reference to the user")
  }

  execute {
    self.userRef.createGallery(name: "DEFAULT")
  }
}
