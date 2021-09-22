import Everbloom from "../../contracts/Everbloom.cdc"

transaction (userAddress: Address) {
  let adminRef: &Everbloom.Admin
  let minterCapability: Capability<&Everbloom.Minter>

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&Everbloom.Admin>(from: Everbloom.AdminStoragePath)
    ?? panic("Could not borrow admin reference")

    if acct.borrow<&Everbloom.Minter>(from: Everbloom.MinterStoragePath) == nil {

      let minter <- self.adminRef.createNewMinter()
      acct.save(<-minter, to: Everbloom.MinterStoragePath)
      self.minterCapability = acct.link<&Everbloom.Minter>(Everbloom.MinterPrivatePath, target: Everbloom.MinterStoragePath)
       ?? panic ("Could not minter reference")
    } else {
      self.minterCapability = acct.getCapability<&Everbloom.Minter>(Everbloom.MinterPrivatePath)
    }
  }

  execute {
    let userPublic = getAccount(userAddress)
            .getCapability(Everbloom.UserPublicPath)
            .borrow<&{Everbloom.UserPublic}>()
            ?? panic("Could not get user reference")
    userPublic.setMinterCapability(minterCapability: self.minterCapability)
  }
}
