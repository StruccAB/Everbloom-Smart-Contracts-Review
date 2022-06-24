import Everbloom2 from "../../../contracts/Everbloom2.cdc"

// Transaction to create a new User resource and store it in user storage.
// This transaction also exposes the public capability of the user

transaction {
  let userRef: &Everbloom2.User

  prepare(acct: AuthAccount) {
    if acct.borrow<&Everbloom2.User>(from: Everbloom2.UserStoragePath) == nil {
      acct.save<@Everbloom2.User>(<- Everbloom2.createUser(), to: Everbloom2.UserStoragePath)
      acct.link<&{Everbloom2.UserPublic}>(Everbloom2.UserPublicPath, target: Everbloom2.UserStoragePath)
    }

    self.userRef = acct.borrow<&Everbloom2.User>(from: Everbloom2.UserStoragePath)
            ?? panic("Could not borrow a reference to the user")
  }
}
