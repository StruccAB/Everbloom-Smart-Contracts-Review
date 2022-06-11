import EverbloomV2 from "../../../contracts/EverbloomV2.cdc"

transaction (userAddress: Address) {
  let minterCapability: Capability<&EverbloomV2.Minter>

  prepare(acct: AuthAccount) {
    pre {
      acct.borrow<&EverbloomV2.Admin>(from: EverbloomV2.AdminStoragePath) != nil: "Could not borrow admin reference"
      acct.borrow<&EverbloomV2.Minter>(from: EverbloomV2.MinterStoragePath) != nil: "Could not borrow minter reference"
    }

    self.minterCapability = acct.getCapability<&EverbloomV2.Minter>(EverbloomV2.MinterPrivatePath)
  }

  execute {
    let userPublic = getAccount(userAddress)
      .getCapability(EverbloomV2.UserPublicPath)
      .borrow<&{EverbloomV2.UserPublic}>()
        ?? panic("Could not get user public reference")
    userPublic.setMinterCapability(minterCapability: self.minterCapability)
  }
}
