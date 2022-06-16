import Everbloom from "../../contracts/Everbloom.cdc"

transaction (userAddress: Address) {
  let minterCapability: Capability<&Everbloom.Minter>

  prepare(acct: AuthAccount) {
    pre {
      acct.borrow<&Everbloom.Admin>(from: Everbloom.AdminStoragePath) != nil: "Could not borrow admin reference"
      acct.borrow<&Everbloom.Minter>(from: Everbloom.MinterStoragePath) != nil: "Could not borrow minter reference"
    }

    self.minterCapability = acct.getCapability<&Everbloom.Minter>(Everbloom.MinterPrivatePath)
  }

  execute {
    let userPublic = getAccount(userAddress)
      .getCapability(Everbloom.UserPublicPath)
      .borrow<&{Everbloom.UserPublic}>()
        ?? panic("Could not get user public reference")
    userPublic.setMinterCapability(minterCapability: self.minterCapability)
  }
}
