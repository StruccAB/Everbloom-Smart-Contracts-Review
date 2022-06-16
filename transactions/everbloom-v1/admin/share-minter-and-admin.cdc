import Everbloom from "../../contracts/Everbloom.cdc"

// This transaction will create a Minter resource and Admin reosurce and share with the second signer

transaction () {
  let adminRef: &Everbloom.Admin

  prepare(acct: AuthAccount, acct2: AuthAccount) {
    self.adminRef = acct.borrow<&Everbloom.Admin>(from: Everbloom.AdminStoragePath)
    ?? panic("Could not borrow admin reference")

     if acct2.borrow<&Everbloom.Admin>(from: Everbloom.AdminStoragePath)  == nil {
        let admin <- self.adminRef.createNewAdmin()

        acct2.save<@Everbloom.Admin>(<-admin, to: Everbloom.AdminStoragePath)
     }

    if acct2.borrow<&Everbloom.Minter>(from: Everbloom.MinterStoragePath) == nil {
      let minter <- self.adminRef.createNewMinter()

      acct2.save(<-minter, to: Everbloom.MinterStoragePath)
      acct2.link<&Everbloom.Minter>(Everbloom.MinterPrivatePath, target: Everbloom.MinterStoragePath)
       ?? panic ("Could not minter reference")
    }
  }
}
