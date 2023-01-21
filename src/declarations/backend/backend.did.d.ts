import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Proposal {
  'id' : bigint,
  'title' : string,
  'winner' : [] | [boolean],
  'description' : string,
  'author' : Principal,
}
export interface Vote {
  'id' : bigint,
  'votingPowah' : bigint,
  'voter' : Principal,
  'vote' : boolean,
  'idProposal' : bigint,
}
export interface _SERVICE {
  'getVote' : ActorMethod<[bigint], Array<Vote>>,
  'getVoteFromPrincipal' : ActorMethod<[Principal, bigint], Array<Vote>>,
  'get_all_proposals' : ActorMethod<[], Array<Proposal>>,
  'get_all_votes' : ActorMethod<[], Array<Vote>>,
  'get_proposal' : ActorMethod<[bigint], Array<Proposal>>,
  'submit_proposal' : ActorMethod<[string, string], bigint>,
  'vote' : ActorMethod<[bigint, boolean], [] | [bigint]>,
}
