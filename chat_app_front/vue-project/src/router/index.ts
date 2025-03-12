import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '@/views/Login.vue'
import SignupView from '@/views/Signup.vue'
import MessagesView from '@/views/Messages.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/login', // Redireciona para a tela de login por padrão
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
    },
    {
      path: '/signup',
      name: 'signup',
      component: SignupView, // Rota para a tela de cadastro
    },
    {
      path: '/messages',
      name: 'messages',
      component: MessagesView, // Rota para a tela de mensagens
    },
  ],
})

export default router
