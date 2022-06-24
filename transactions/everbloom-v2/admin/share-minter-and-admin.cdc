import Everbloom2 from "../../../contracts/Everbloom2.cdc"

// This transaction will create a Minter resource and Admin reosurce and share with the second signer

transaction () {
  let adminRef: &Everbloom2.Admin

  prepare(acct: AuthAccount, acct2: AuthAccount) {
    self.adminRef = acct.borrow<&Everbloom2.Admin>(from: Everbloom2.AdminStoragePath)
    ?? panic("Could not borrow admin reference")

     if acct2.borrow<&Everbloom2.Admin>(from: Everbloom2.AdminStoragePath)  == nil {
        let admin <- self.adminRef.createNewAdmin()

        acct2.save<@Everbloom2.Admin>(<-admin, to: Everbloom2.AdminStoragePath)
     }

    if acct2.borrow<&Everbloom2.Minter>(from: Everbloom2.MinterStoragePath) == nil {
      let minter <- self.adminRef.createNewMinter()

      acct2.save(<-minter, to: Everbloom2.MinterStoragePath)
      acct2.link<&Everbloom2.Minter>(Everbloom2.MinterPrivatePath, target: Everbloom2.MinterStoragePath)
       ?? panic ("Could not minter reference")
    }
  }
}
