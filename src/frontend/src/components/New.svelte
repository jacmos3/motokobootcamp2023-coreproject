<script>
    import { daoActor, principal } from "../views";
    import { get } from "svelte/store";
    
    let title;
    let description;
    
    async function submit_proposal(title, description) {
      let dao = get(daoActor);
      if (!dao) {
        console.log("dao not loaded");
        return;
      };
      let res = await dao.submit_proposal(title, description);
      if (res > 0) {
        console.log(res);
        return res;
      } else {
        console.log("err "+res.Err);
        throw new Error(res.Err);
      }
    }
    
    var promise; //= submit_proposal(title, description);
    
    function handleClick(title, description) {
      console.log("cliecked");
      promise = submit_proposal(title, description);
      console.log("sent");
    }
    </script>
    
    <div class="mt-10 flex gap-x-4">
      <div class="flex flex-wrap items-center gap-y-8">
        {#if $principal}
          <h1 class="slogan w-full text-3xl font-bold">New Proposal</h1>
    
          {#await promise}
            <p class="w-full" style="color: white">...waiting</p>
          {:then p}
            {#if p}
              <p class="w-full" style="color: white">
                Proposal submitted, returned id: {p}!
              </p>
            {/if}
          {:catch error}
            <p class="w-full" style="color: red">{error.message}</p>
          {/await}
    
          <div class="flex w-full flex-wrap gap-y-4 justify-center">
            <input
              bind:value="{title}"
              class="w-full border border-black text-black px-2 py-2"
              placeholder="Proposal title" />
            <textarea
              bind:value="{description}"
              class="w-full border border-black text-black px-2 py-2"
              placeholder="Proposal description"></textarea>
            <button
              class="w-3/4 border bg-white px-4 py-2 text-black hover:border-none hover:bg-lime-400 hover:shadow-hard"
              on:click="{handleClick(title, description)}"
              >Submit</button>
          </div>
        {:else}
          <p class="example-disabled">
            Connect to a wallet first.
          </p>
        {/if}
      </div>
    </div>
    