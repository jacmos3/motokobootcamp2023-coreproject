import { principal } from "../views";
import { daoActor } from "../views";
import { idlFactory as idlFactoryDAO } from "../../../declarations/backend/backend.did.js";
import { HttpAgent, Actor } from "@dfinity/agent";

//TODO : Add your mainnet id whenever you have deployed on the IC
const daoCanisterId =
  process.env.NODE_ENV === "development"
    ? "xdai7-gaaaa-aaaak-aeacq-cai" 
    : "xdai7-gaaaa-aaaak-aeacq-cai"; //IC

// See https://docs.plugwallet.ooo/ for more informations
export async function plugConnection() {
  const result = await window.ic.plug.requestConnect({
    whitelist: [daoCanisterId],
  });
  if (!result) {
    throw new Error("User denied the connection");
  }
  const p = await window.ic.plug.agent.getPrincipal();
  p.id = await window.ic.plug.principalId;

  const agent = new HttpAgent({
    host: "https://ic0.app",
/*      process.env.NODE_ENV === "development"
        ? "http://localhost:5000"
        : "https://ic0.app",*/
  });

  if (process.env.NODE_ENV === "development") {
    agent.fetchRootKey();
  }

  const actor = Actor.createActor(idlFactoryDAO, {
    agent,
    canisterId: daoCanisterId,
  });

  console.log(actor);

  principal.update(() => p);
  daoActor.update(() => actor);
}
