<script>
  import { link } from "svelte-spa-router";

  function getActive(t) {
    if (t.includes("#/ambassadors") || t == "AMBASSADORS") {
      return "ambassadors";
    } else if (t.includes("#/circles") || t == "CIRCLES") {
      return "circles";
    }else if (t.includes("#/values") || t == "VALUES") {
      return "values";
    }
    return "home";
  }

  $: active = getActive(location.href);

  let navcheck;
  function linkClick(evt) {
    navcheck.checked = false;
    var t = evt.target.innerText;
    active = getActive(t);
  }
</script>

<!-- Header -->
<header id="header">
  <div class="brand-logo">
    <a href="https://threefold.io/" target="_blank">
      <img src="/images/TFN.svg" alt="" />
    </a>
  </div>

  <input type="checkbox" id="toggle-btn" bind:this={navcheck} />
  <label for="toggle-btn" class="show-menu-btn">
    <i class="fas fa-bars" />
  </label>

  <nav class="d-inline-block">
    <ul class="navigation">
      <li>
        {#if active == 'home'}
          <a class="active" href="#/" on:click={linkClick}>Home</a>
        {:else}
          <a href="#/" on:click={linkClick}>Home</a>
        {/if}
      </li>
      <li>
        {#if active == 'circles'}
          <a class="active" href="#/circles" on:click={linkClick}>Circles</a>
        {:else}
          <a href="#/circles" on:click={linkClick}>Circles</a>
        {/if}
      </li>
      <li>
        {#if active == 'ambassadors'}
          <a class="active" href="#/ambassadors" on:click={linkClick}>Ambassadors</a>
        {:else}
          <a href="#/ambassadors" on:click={linkClick}>Ambassadors</a>
        {/if}
      </li>

      <li>
        {#if active == 'values'}
          <a class="active" href="#/values" on:click={linkClick}>Values</a>
        {:else}
          <a href="#/values" on:click={linkClick}>Values</a>
        {/if}
      </li>

      <label for="toggle-btn" class="hide-menu-btn">
        <i class="fas fa-times" />
      </label>
    </ul>
  </nav>

  <nav class="main">
    <ul>
      <li class="search">
        <a class="fa-search" href="#search">Search</a>
        <form id="search">
          <input type="text" name="query" placeholder="Search" />
        </form>
      </li>
    </ul>
  </nav>
</header>
