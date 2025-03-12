# Chat App - Sistema de Troca de Mensagens

Bem-vindo ao **Chat App**, uma aplicação completa para troca de mensagens entre usuários, desenvolvida com **Ruby on Rails** no backend e **Vue.js** no frontend. Este projeto foi criado como parte de um desafio técnico para demonstrar habilidades em desenvolvimento full-stack, seguindo boas práticas e implementando funcionalidades modernas.

---

## **Funcionalidades Principais**

### Backend (Ruby on Rails)
- **Autenticação de Usuários**: Utilização de **JWT (JSON Web Tokens)** para garantir segurança e restrição de acesso.
- **Envio de Mensagens**: Endpoint `POST /messages` para enviar mensagens entre usuários, com suporte para anexos de arquivos.
- **Recuperação de Mensagens**: Endpoint `GET /messages` para listar mensagens enviadas e recebidas pelo usuário autenticado.
- **Banco de Dados Relacional**: Uso de **PostgreSQL** para armazenamento de dados.
- **WebSocket**: Implementação de comunicação em tempo real com **ActionCable**, permitindo que as mensagens sejam atualizadas instantaneamente.

### Frontend (Vue.js)
- **Interface de Autenticação**: Tela simples para autenticação de usuários.
- **Listagem de Mensagens**: Exibição organizada das mensagens, agrupadas por usuário.
- **Envio de Mensagens**: Campo para composição e envio de novas mensagens, com suporte para anexos.
- **Paginação**: Carregamento de mensagens antigas sob demanda, melhorando a performance e a experiência do usuário.
- **Interface Responsiva**: Design adaptável para diferentes dispositivos.

---

## **Tecnologias Utilizadas**

### Backend
- **Ruby on Rails**: Framework para desenvolvimento rápido e seguro de APIs.
- **JWT**: Autenticação segura e stateless.
- **ActionCable**: Implementação de WebSocket para comunicação em tempo real.
- **PostgreSQL**: Banco de dados relacional robusto e escalável.
- **Active Storage**: Gerenciamento de uploads de arquivos.

### Frontend
- **Vue.js**: Framework JavaScript para construção de interfaces modernas e reativas.
- **Axios**: Cliente HTTP para comunicação com a API.
- **WebSocket**: Integração com o backend para atualizações em tempo real.
- **Vuetify** (ou outra biblioteca de componentes): Para uma interface mais amigável e responsiva.

---

## **Como Executar o Projeto**

### Pré-requisitos
- **Ruby**: Versão 3.x.x
- **Rails**: Versão 7.x.x
- **Node.js**: Versão 16.x.x
- **SQLite**: Banco de dados configurado e rodando.

### 1. Clonar o repositório
```sh
  git clone https://github.com/J6N6S6/Chat-App---DESAFIORB.git
  cd Chat-App---DESAFIORB
```

### 2. Configurar o Backend
```sh
  bundle install
  rails db:create db:migrate
  rails server
```

### 3. Configurar o Frontend
```sh
  cd chat_app_front
  npm install
  npm run dev
```

## Uso

1. **Criar um usuário:**
```sh
  curl -X POST http://localhost:3000/signup -H "Content-Type: application/json" -d '{"name": "Jonas", "email": "jonas@example.com", "password": "123456"}'
```

2. **Fazer login:**
```sh
  curl -X POST http://localhost:3000/login -H "Content-Type: application/json" -d '{"email": "jonas@example.com", "password": "123456"}'
```

3. **Enviar uma mensagem:**
```sh
  curl -X POST http://localhost:3000/messages -H "Authorization: Bearer <TOKEN>" -H "Content-Type: application/json" -d '{"receiver_id": 2, "encrypted_content": "Mensagem criptografada"}'
```

4. **Listar mensagens:**
```sh
  curl -X GET http://localhost:3000/messages -H "Authorization: Bearer <TOKEN>"
```

5. **Baixar um arquivo:**
```sh
  curl -X GET http://localhost:3000/files/1 -H "Authorization: Bearer <TOKEN>" --output arquivo_baixado.txt
```

## Autor

**Jonas dos Santos Candeias**  
[LinkedIn](https://www.linkedin.com/in/scjonas/)  
[Repositório](https://github.com/J6N6S6/Chat-App---DESAFIORB)

---

Se tiver dúvidas ou sugestões, sinta-se à vontade para abrir uma *issue* ou entrar em contato! 🚀
