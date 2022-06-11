import EverbloomV2 from "../../../contracts/EverbloomV2.cdc"

// This transaction will create a Minter resource and Admin reosurce and share with the second signer

transaction () {
  let adminRef: &EverbloomV2.Admin

  prepare(acct: AuthAccount, acct2: AuthAccount) {
    self.adminRef = acct.borrow<&EverbloomV2.Admin>(from: EverbloomV2.AdminStoragePath)
    ?? panic("Could not borrow admin reference")

     if acct2.borrow<&EverbloomV2.Admin>(from: EverbloomV2.AdminStoragePath)  == nil {
        let admin <- self.adminRef.createNewAdmin()

        acct2.save<@EverbloomV2.Admin>(<-admin, to: EverbloomV2.AdminStoragePath)
     }

    if acct2.borrow<&EverbloomV2.Minter>(from: EverbloomV2.MinterStoragePath) == nil {
      let minter <- self.adminRef.createNewMinter()

      acct2.save(<-minter, to: EverbloomV2.MinterStoragePath)
      acct2.link<&EverbloomV2.Minter>(EverbloomV2.MinterPrivatePath, target: EverbloomV2.MinterStoragePath)
       ?? panic ("Could not minter reference")
    }
  }
}
