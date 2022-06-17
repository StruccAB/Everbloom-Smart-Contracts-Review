import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// This transaction will disable a perk

transaction (perkID: UInt32) {
  let adminRef: &EverbloomV2.Admin

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&EverbloomV2.Admin>(from: EverbloomV2.AdminStoragePath)
    ?? panic("Could not borrow admin reference")
  }

  execute {
    self.adminRef.invalidatePerk(perkID: perkID)
  }
}
