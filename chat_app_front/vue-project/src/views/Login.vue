<template>
  <div class="login-container">
    <div class="left-section"></div>
    <div class="right-section">
      <div class="login-box">
        <h1>Bem-vindo ao <span class="app-name">messaJ</span></h1>
        <form @submit.prevent="login">
          <input v-model="email" type="email" placeholder="Email" required />
          <input v-model="password" type="password" placeholder="Senha" required />
          <button type="submit">Entrar</button>
        </form>
        <p v-if="error" class="error">{{ error }}</p>
        <p class="register-link">
          Não tem uma conta? <router-link to="/signup">Cadastre-se</router-link>
        </p>
      </div>
      <footer class="footer">
        <p>
          Feito por
          <a href="https://www.linkedin.com/in/scjonas/" target="_blank" rel="noopener noreferrer"
            >Jonas</a
          >
        </p>
      </footer>
    </div>
  </div>
</template>

<script lang="ts">
import api from '@/api'

export default {
  name: 'LoginView',
  data() {
    return {
      email: '',
      password: '',
      error: '',
    }
  },
  methods: {
    async login() {
      try {
        const response = await api.post('/login', {
          email: this.email,
          password: this.password,
        })
        localStorage.setItem('token', response.data.token)
        this.$router.push('/messages')
      } catch (err) {
        this.error = 'Email ou senha inválidos'
        console.error('Erro no login:', err)
      }
    },
  },
}
</script>

<style scoped>
/* Reset de margens e paddings */
html,
body,
#app,
.app {
  display: flex;
  margin: 0;
  padding: 0;
  height: 100%;
  width: 100%;
  /*overflow: hidden;*/
}

.login-container {
  display: flex;
  height: 100%;
  width: 100%;
  margin: 0;
  padding: 0;
}

.left-section {
  flex: 60%;
  background-color: #000; /* Fundo preto */
}

.right-section {
  /*flex: 40%; /* 40% da tela */
  background-color: #fff; /* Fundo branco */
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  padding: 2rem; /* Espaçamento interno */
  box-sizing: border-box; /* Garante que o padding não aumente o tamanho */
}

.login-box {
  width: 100%;
  max-width: 400px;
  text-align: center;
}

h1 {
  color: #333;
  margin-bottom: 1.5rem;
  font-size: 1.5rem;
}

.app-name {
  color: #4caf50;
  font-weight: bold;
}

input {
  width: 100%;
  padding: 0.75rem;
  margin-bottom: 1rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
}

button {
  width: 100%;
  padding: 0.75rem;
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
}

button:hover {
  background-color: #45a049;
}

.error {
  color: red;
  margin-top: 1rem;
}

.register-link {
  margin-top: 1rem;
  color: #333;
}

.register-link a {
  color: #4caf50;
  text-decoration: none;
}

.register-link a:hover {
  text-decoration: underline;
}

.footer {
  margin-top: 2rem;
  text-align: center;
  color: #666;
}

.footer a {
  color: #4caf50;
  text-decoration: none;
}

.footer a:hover {
  text-decoration: underline;
}

html,
body {
  margin: 0;
  padding: 0;
  height: 100%;
  /*overflow: hidden; */
}
</style>
