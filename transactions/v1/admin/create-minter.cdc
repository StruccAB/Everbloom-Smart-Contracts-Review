import Everbloom from "../../contracts/Everbloom.cdc"

// This transaction will create a Minter resource and will store it in admin private path

transaction () {
  let adminRef: &Everbloom.Admin

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&Everbloom.Admin>(from: Everbloom.AdminStoragePath)
    ?? panic("Could not borrow admin reference")

    if acct.borrow<&Everbloom.Minter>(from: Everbloom.MinterStoragePath) == nil {
      let minter <- self.adminRef.createNewMinter()

      acct.save(<-minter, to: Everbloom.MinterStoragePath)
      acct.link<&Everbloom.Minter>(Everbloom.MinterPrivatePath, target: Everbloom.MinterStoragePath)
       ?? panic ("Could not minter reference")
    }
  }
}
