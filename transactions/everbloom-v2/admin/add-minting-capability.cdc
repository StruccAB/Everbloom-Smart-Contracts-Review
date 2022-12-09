import Everbloom2 from "../../../contracts/Everbloom2.cdc"

transaction (userAddress: Address) {
  let minterCapability: Capability<&Everbloom2.Minter>

  prepare(acct: AuthAccount) {
    pre {
      acct.borrow<&Everbloom2.Admin>(from: Everbloom2.AdminStoragePath) != nil: "Could not borrow admin reference"
      acct.borrow<&Everbloom2.Minter>(from: Everbloom2.MinterStoragePath) != nil: "Could not borrow minter reference"
    }

    self.minterCapability = acct.getCapability<&Everbloom2.Minter>(Everbloom2.MinterPrivatePath)
  }

  execute {
    let userPublic = getAccount(userAddress)
      .getCapability(Everbloom2.UserPublicPath)
      .borrow<&{Everbloom2.UserPublic}>()
        ?? panic("Could not get user public reference")
    userPublic.setMinterCapability(minterCapability: self.minterCapability)
  }
}
