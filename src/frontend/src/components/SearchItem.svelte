<script>
  import marked from "marked";
  export let item;
</script>

<article class="post search_result">
  <header>
    <div class="title">
      {#if item.isUser}
        <h3>Ambassador:</h3>
        <a class="author"  href="#/ambassadors/{item.name}">
        <img src={item.links.image_path} alt="" />
        {item.info.name}
      </a>
      {:else}
        <h3>Circle:</h3>
        <a class="author" href="#/circles/{item.name}">
        <img src={item.links.image_path} alt="" />
        {item.info.name}
      </a>
      {/if}
      

    </div>
  </header>
</article>
