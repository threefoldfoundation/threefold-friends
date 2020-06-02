<script>
  if (location.pathname != "/") {
    location.href = "/";
  }

  import { ambassadors } from "../../store.js";
  import marked from "marked";

</script>

<!-- Wrapper -->
<div id="wrapper">

  <!-- Main -->
  <div id="main">

    <!-- Post -->
    <article class="container font-weight-normal">
      <div class="row">
        <!-- <span class="image featured">
          <img src="images/green-header2.png" alt="" />
        </span> -->
        {@html marked($ambassadors['home'])}
      </div>
    </article>
  </div>
</div>
