<template>
  <div class="signup-container">
    <div class="left-section"></div>
    <div class="right-section">
      <div class="signup-box">
        <h1>Criar uma conta no <span class="app-name">messaJ</span></h1>
        <form @submit.prevent="signup">
          <input v-model="name" type="text" placeholder="Nome" required />
          <input v-model="email" type="email" placeholder="Email" required />
          <input v-model="password" type="password" placeholder="Senha" required />
          <button type="submit">Cadastrar</button>
        </form>
        <p v-if="error" class="error">{{ error }}</p>
        <p class="login-link">
          Já tem uma conta? <router-link to="/login">Faça login</router-link>
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
  name: 'SignupView',
  data() {
    return {
      name: '',
      email: '',
      password: '',
      error: '',
    }
  },
  methods: {
    async signup() {
      try {
        await api.post('/users', {
          name: this.name,
          email: this.email,
          password: this.password,
        })
        this.$router.push('/login') // Redireciona para a tela de login após o cadastro
      } catch (err) {
        this.error = 'Erro ao cadastrar usuário'
        console.error('Erro no cadastro:', err)
      }
    },
  },
}
</script>

<style scoped>
.signup-container {
  display: flex;
  height: 100vh;
  width: 100vw;
  margin: 0;
  padding: 0;
}

.left-section {
  flex: 1.5; /* 60% da tela */
  background-color: #000; /* Fundo preto */
}

.right-section {
  flex: 1; /* 40% da tela */
  background-color: #fff; /* Fundo branco */
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  padding: 2rem;
  box-sizing: border-box;
}

.signup-box {
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

.login-link {
  margin-top: 1rem;
  color: #333;
}

.login-link a {
  color: #4caf50;
  text-decoration: none;
}

.login-link a:hover {
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
</style>
