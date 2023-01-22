<script>
  import { daoActor, principal } from "../views";
  import { get } from "svelte/store";
  export let proposal;
  var status = "";
  var statusCss = "";
  if (proposal.winner == false){
    status = "REJECTED";
    statusCss = "bg-red-400";
  }
  else
  if (proposal.winner == true){
    status = "APPROVED";
    statusCss = "bg-green-400";
  }
  else{
    status = "OPEN";
    statusCss = "bg-yellow-400";
  }

  console.log(proposal);

  async function voteFor(id, vote) {
      let dao = get(daoActor);
      if (!dao) {
        console.log("dao not loaded");
        return;
      };
      let res = await dao.vote(id, vote);
      if (res > 0) {
        console.log(res);
        return res;
      } else {
        console.log("err "+res.Err);
        throw new Error(res.Err);
      }
    }

  var promise; 

  const handleVote = (id, vote) => {
    console.log("vote Clicked - " + id, vote);
    promise = voteFor(id,vote);
  };

  </script>
  
  <div class="flex flex-wrap gap-y-4 text-white">
    <div class="w-full mb-2">
      <div class="flex items-center gap-y-2 gap-x-2">
        <div class="flex items-center">
          <span class="mr-2 align-baseline font-black uppercase">
            Id:
          </span>
          <span class="bg-black-400 px-2 text-sm text-white">
            {proposal.id}
          </span>
        </div>
        <div class="flex items-center">
          <span class="mr-2 align-baseline font-black uppercase">
            Author:
          </span>
          <span class="bg-green-400 px-2 text-sm text-white">
            {proposal.author}
          </span>
        </div>
        <div class="flex items-center">
          <span class="mr-2 align-baseline font-black uppercase">
            STATUS:
          </span>
          <span 
            class="{statusCss} px-2 text-sm text-white">
            {status}
          </span>
        </div>
      </div>
      <div class="flex items-center gap-y-2 text-3xl">
        <span class="mr-2 align-baseline font-black uppercase">
          Title:
        </span>
        {proposal.title}
      </div>
      
    </div>
    <div class="flex flex-wrap gap-y-2 mb-2">
      <div class="w-full text-xs font-black uppercase">Description:</div>
      <p class="w-full">{proposal.description}</p>
    </div>
    {#if proposal.winner != false && proposal.winner != true}
    <div class="flex flex-wrap w-full gap-y-2">
      <div class="w-full flex gap-x-2">
        <div class="w-1/2">
          <button 
            class="w-full bg-green-200 hover:bg-green-400 text-black hover:text-black px-4 py-2 hover:shadow-hard text-sm hover:uppercase hover:font-black"
            on:click="{() => handleVote(proposal.id, true)}"
            >
            Approve
          </button>
        </div>
        <div class="w-1/2 flex gap-x-2">
          <button 
            class="w-full bg-red-200 hover:bg-red-500 text-black hover:text-black px-4 py-2 hover:shadow-hard text-sm hover:uppercase hover:font-black"
            on:click="{() => handleVote(proposal.id, false)}"
            >
            Reject
          </button>
        </div>
      </div>
    </div>
    {/if}
  </div>
  