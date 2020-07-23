<template>
  <div id="app">
    <img class="logo" alt="JMLink logo" src="./assets/logo.png" />
    <p>
      <a id="openApp" ref="openApp">打开APP</a>
    </p>
  </div>
</template>

<script>
export default {
  name: 'App',
  mounted() {
    const btn = this.$refs.openApp;
     new JMLink({
        jmlink: 'https://arguys.jmlk.co/AAlq?a=1',
        button: btn,
        params: {
          name: 'xxx',
        },
        plhparams: {
          type: 3,
        },
        invtparams: {
          u_id: '6666',
        },
      });
  },
};
</script>

<style>
#app {
  height: 100vh;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  padding-top: 20%;
}

.logo {
  width: 100px;
}

p {
  margin-top: 80%;
}

a {
  font-size: 16px;
  text-decoration: none;
  padding: 10px 16px;
  background-color: blue;
  color: #fff;
}
</style>
