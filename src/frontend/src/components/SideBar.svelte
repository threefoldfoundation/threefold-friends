<script>
  import MiniProjectList from "./MiniProjectList.svelte";
  import MiniUserList from "./MiniUserList.svelte";
  import TagCloud from "./TagCloud.svelte"

  import Footer from "./Footer.svelte";
  import { alltags } from "../../store.js";

  export let miniProjects = [];
  export let users = [];
</script>

<!-- Sidebar -->
<section id="sidebar">
  <!-- Intro -->
  <section id="intro">
    <!-- <a href="/" class="logo">
      <img src="images/logo.png" alt="" />
    </a> -->
    <header>
      <h1>Threefold Ambassadors</h1>
      <p>
        
      </p>
    </header>
  </section>

  <TagCloud tags={$alltags} />

  <!-- Mini Projects -->
  


{#if location.href.includes("#/ambassadors")}
  <MiniUserList {users} />
  {:else}
<MiniProjectList {miniProjects} />  

{/if}
  
</section>
