import { writable } from "svelte/store";

export const view = writable({
  new: 1,
  view: 2,
  vote: 3,
  current: 1,
});

export const proposaltoVote = writable({
  proposalID: "null",
});

export const principal = writable(null);
export const daoActor = writable(null);
