<template>
  <div class="messages-container">
    <div class="header">
      <h1>Mensagens</h1>
      <button @click="logout" class="logout-button">Sair</button>
    </div>

    <div class="new-message-form">
      <h2>Enviar Nova Mensagem</h2>
      <form @submit.prevent="sendMessage">
        <input
          v-model="newMessage.receiver"
          type="text"
          placeholder="Nome do destinatário"
          required
        />
        <textarea
          v-model="newMessage.encrypted_content"
          placeholder="Escreva sua mensagem..."
          required
        ></textarea>
        <input type="file" @change="handleFileUpload" />
        <button type="submit" class="send-button">Enviar</button>
      </form>
    </div>

    <div class="conversations-list">
      <div v-for="(messages, user) in groupedMessages" :key="user" class="conversation">
        <div class="conversation-header" @click="toggleConversation(user.toString())">
          <h3>
            {{
              users[parseInt(user.toString())]
                ? users[parseInt(user.toString())]
                : `Usuário ${user}`
            }}
          </h3>
          <span>{{ messages.length }} mensagens</span>
        </div>
        <div v-if="openConversations.includes(user.toString())" class="messages">
          <div v-for="message in messages" :key="message.id" class="message-item">
            <p>{{ message.encrypted_content }}</p>
            <small
              >Enviado por: {{ users[message.sender_id] || `Usuário ${message.sender_id}` }} em
              {{ formatDate(message.created_at) }}</small
            >
            <div v-if="message.file_url" class="file-link">
              <a :href="message.file_url" target="_blank">Baixar anexo</a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="load-more-container">
      <button @click="loadMore" v-if="hasMore" class="load-more-button">Carregar mais</button>
    </div>
  </div>
</template>

<script lang="ts">
import api from '@/api'
import { createConsumer } from '@rails/actioncable'

interface Message {
  id: number
  encrypted_content: string
  sender_id: number
  receiver_id: number
  created_at: string
  file_url?: string
}

export default {
  name: 'MessagesView',
  data() {
    return {
      messages: [] as Message[],
      newMessage: {
        receiver: '',
        encrypted_content: '',
        file: null as File | null,
      },
      openConversations: [] as string[],
      page: 1,
      perPage: 10,
      totalPages: 1,
      hasMore: true,
      users: {} as { [key: number]: string },
      currentUser: { id: 13 }, // Substitua pelo ID do usuário logado
    }
  },
  computed: {
    groupedMessages() {
      const grouped: { [key: string]: Message[] } = {}
      this.messages.forEach((message) => {
        const user = message.receiver_id.toString()
        if (!grouped[user]) {
          grouped[user] = []
        }
        grouped[user].push(message)
      })
      return grouped
    },
  },
  async created() {
    await this.fetchMessages()

    const cable = createConsumer('ws://localhost:3000/cable', {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token')}`,
      },
    })

    // Assinar o canal de mensagens
    cable.subscriptions.create(
      { channel: 'MessagesChannel', user_id: this.currentUser.id },
      {
        received: (data: { type: string; message: Message }) => {
          if (data.type === 'new_message') {
            // Adicionar a nova mensagem à lista
            this.messages.unshift(data.message)

            // Atualizar os nomes dos usuários, se necessário
            this.fetchUserNamesForMessage(data.message)
          }
        },
      },
    )
  },
  methods: {
    async fetchMessages() {
      try {
        const response = await api.get('/messages', {
          params: {
            page: this.page,
            per_page: this.perPage,
          },
        })
        this.messages = [...this.messages, ...response.data.messages]

        await this.fetchUserNames()
      } catch (err) {
        console.error('Erro ao carregar mensagens:', err)
      }
    },
    async fetchUserNames() {
      const userIds = [
        ...new Set(this.messages.flatMap((message) => [message.sender_id, message.receiver_id])),
      ]

      for (const userId of userIds) {
        if (!this.users[userId]) {
          try {
            const userResponse = await api.get(`/users/${userId}`)
            this.users[userId] = userResponse.data.name
          } catch (error) {
            console.error(`Erro ao buscar usuário ${userId}:`, error)
            this.users[userId] = userId.toString()
          }
        }
      }
    },
    async fetchUserNamesForMessage(message: Message) {
      const userIds = [message.sender_id, message.receiver_id]

      for (const userId of userIds) {
        if (!this.users[userId]) {
          try {
            const userResponse = await api.get(`/users/${userId}`)
            this.users[userId] = userResponse.data.name
          } catch (error) {
            console.error(`Erro ao buscar usuário ${userId}:`, error)
            this.users[userId] = userId.toString()
          }
        }
      }
    },
    async sendMessage() {
      try {
        const receiverResponse = await api.get('/users/find', {
          params: {
            email: this.newMessage.receiver,
          },
        })

        const receiverId = receiverResponse.data.id

        const formData = new FormData()
        formData.append('receiver_id', receiverId.toString())
        formData.append('encrypted_content', this.newMessage.encrypted_content)
        if (this.newMessage.file) {
          formData.append('file', this.newMessage.file)
        }

        const response = await api.post('/messages', formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        })

        this.messages.unshift(response.data)
        this.newMessage.receiver = ''
        this.newMessage.encrypted_content = ''
        this.newMessage.file = null

        alert('Mensagem enviada com sucesso!')
      } catch (err) {
        console.error('Erro ao enviar mensagem:', err)
        alert('Erro ao enviar mensagem.')
      }
    },
    handleFileUpload(event: Event) {
      const input = event.target as HTMLInputElement
      if (input.files && input.files[0]) {
        this.newMessage.file = input.files[0]
      }
    },
    toggleConversation(user: string) {
      if (this.openConversations.includes(user)) {
        this.openConversations = this.openConversations.filter((u) => u !== user)
      } else {
        this.openConversations.push(user)
      }
    },
    async loadMore() {
      this.page += 1
      await this.fetchMessages()
    },
    logout() {
      localStorage.removeItem('token')
      this.$router.push('/login')
    },
    formatDate(dateString: string) {
      const date = new Date(dateString)
      return date.toLocaleString()
    },
  },
}
</script>

<style scoped>
.messages-container {
  padding: 2rem;
  background-color: #f5f5f5;
  min-height: 100vh;
  max-width: 800px;
  margin: 0 auto;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

h1 {
  color: #4caf50;
  margin: 0;
}

.logout-button {
  background-color: #4caf50;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
}

.logout-button:hover {
  background-color: #45a049;
}

.new-message-form {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  margin-bottom: 2rem;
}

.new-message-form h2 {
  margin-top: 0;
  margin-bottom: 1.5rem;
  color: #333;
}

.new-message-form input,
.new-message-form textarea {
  width: 100%;
  padding: 0.75rem;
  margin-bottom: 1rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
}

.new-message-form textarea {
  height: 100px;
  resize: vertical;
}

.new-message-form .send-button {
  width: 100%;
  padding: 0.75rem;
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
}

.new-message-form .send-button:hover {
  background-color: #45a049;
}

.conversations-list {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.conversation {
  margin-bottom: 1.5rem;
}

.conversation-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background-color: #f9f9f9;
  border-radius: 4px;
  cursor: pointer;
}

.conversation-header h3 {
  margin: 0;
  color: #333;
}

.conversation-header span {
  color: #666;
}

.messages {
  margin-top: 1rem;
}

.message-item {
  border-bottom: 1px solid #333;
  padding: 1rem 0;
}

.message-item:last-child {
  border-bottom: none;
}

.file-link a {
  color: #4caf50;
  text-decoration: none;
}

.file-link a:hover {
  text-decoration: underline;
}

.load-more-container {
  text-align: center;
  margin-top: 2rem;
}

.load-more-button {
  padding: 0.75rem 1.5rem;
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
}

.load-more-button:hover {
  background-color: #45a049;
}

.message-item p {
  color: #333;
  margin: 0;
  font-size: 1rem;
  line-height: 1.5;
}

.message-item small {
  color: #666;
  font-size: 0.875rem;
}
</style>
