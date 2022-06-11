import EverbloomV2 from "../../../contracts/EverbloomV2.cdc"

// Transaction to create a new User resource and store it in user storage.
// This transaction also exposes the public capability of the user

transaction {
  let userRef: &EverbloomV2.User

  prepare(acct: AuthAccount) {
    if acct.borrow<&EverbloomV2.User>(from: EverbloomV2.UserStoragePath) == nil {
      acct.save<@EverbloomV2.User>(<- EverbloomV2.createUser(), to: EverbloomV2.UserStoragePath)
      acct.link<&{EverbloomV2.UserPublic}>(EverbloomV2.UserPublicPath, target: EverbloomV2.UserStoragePath)
    }

    self.userRef = acct.borrow<&EverbloomV2.User>(from: EverbloomV2.UserStoragePath)
            ?? panic("Could not borrow a reference to the user")
  }
}
