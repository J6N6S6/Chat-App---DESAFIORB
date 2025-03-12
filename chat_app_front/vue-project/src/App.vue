<template>
  <div class="app">
    <router-view />
  </div>
</template>

<script lang="ts">
export default {
  name: 'App',
}
</script>

<style>
/* Garantindo que o app ocupe a tela inteira */
html,
body,
#app,
.app {
  display: flex;
  margin: 0;
  padding: 0;
  height: 100%;
  width: 100%;
}
</style>
