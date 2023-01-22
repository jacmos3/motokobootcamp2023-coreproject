<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://unpkg.com/tailwindcss@^1.0/dist/tailwind.min.css" rel="stylesheet">
</head>
<script>
  import {view} from "./views.js";

  import Header from "./components/head/Header.svelte"; 
  import Home from "./components/Home.svelte";
  import Vote from "./components/Vote.svelte";
  import View from "./components/View.svelte";
  import New from "./components/New.svelte";

  </script>

<div class="App">
  <Header />

  <div >
    {#if $view.current === $view.home}
      <Home />
    {:else if $view.current === $view.view}
      <View />
    {:else if $view.current === $view.vote}
      <Vote />
    {:else if $view.current === $view.new}
      <New />
    {/if}
  </div>

  <footer></footer>
</div>


