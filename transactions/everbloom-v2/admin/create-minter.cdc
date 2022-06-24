import Everbloom2 from "../../../contracts/Everbloom2.cdc"

// This transaction will create a Minter resource and will store it in admin private path

transaction () {
  let adminRef: &Everbloom2.Admin

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&Everbloom2.Admin>(from: Everbloom2.AdminStoragePath)
    ?? panic("Could not borrow admin reference")

    if acct.borrow<&Everbloom2.Minter>(from: Everbloom2.MinterStoragePath) == nil {
      let minter <- self.adminRef.createNewMinter()

      acct.save(<-minter, to: Everbloom2.MinterStoragePath)
      acct.link<&Everbloom2.Minter>(Everbloom2.MinterPrivatePath, target: Everbloom2.MinterStoragePath)
       ?? panic ("Could not minter reference")
    }
  }
}
