import Everbloom from "../../contracts/Everbloom.cdc"

// Transaction to create a new User resource and store it in user storage.
// This transaction also exposes the public capability of the user

transaction {
  let userRef: &Everbloom.User

  prepare(acct: AuthAccount) {
    if acct.borrow<&Everbloom.User>(from: Everbloom.UserStoragePath) == nil {
      acct.save<@Everbloom.User>(<- Everbloom.createUser(), to: Everbloom.UserStoragePath)
      acct.link<&{Everbloom.UserPublic}>(Everbloom.UserPublicPath, target: Everbloom.UserStoragePath)
    }

    self.userRef = acct.borrow<&Everbloom.User>(from: Everbloom.UserStoragePath)
            ?? panic("Could not borrow a reference to the user")
  }
}
