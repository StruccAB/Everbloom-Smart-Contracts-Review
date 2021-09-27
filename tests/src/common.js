import { getAccountAddress } from "flow-js-testing";

export const getEverbloomAdminAddress = async () => getAccountAddress("EverbloomAdmin");
export const getUserBobAddress = async () => getAccountAddress("Bob")
export const getUserAliceAddress = async () => getAccountAddress("Alice")
