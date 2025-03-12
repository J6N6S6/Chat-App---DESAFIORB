class MessagesController < ApplicationController
  before_action :authenticate_user

  # Listar mensagens com paginação
  def index
    # Paginação
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    # Buscar mensagens do usuário atual
    messages = Message.where(sender_id: @current_user.id).or(Message.where(receiver_id: @current_user.id))
                     .order(created_at: :desc)
                     .page(page)
                     .per(per_page)

    # Formatar a resposta
    render json: {
      messages: messages.map { |message| format_message(message) },
      pagination: {
        current_page: messages.current_page,
        total_pages: messages.total_pages,
        total_count: messages.total_count,
        per_page: messages.limit_value
      }
    }
  end

  # Enviar mensagem
  def create
  receiver = User.find_by(id: params[:receiver_id])
  if receiver.nil?
    render json: { error: "Destinatário não encontrado" }, status: :unprocessable_entity
    return
  end

  message = Message.new(message_params)
  message.sender_id = current_user.id
  message.receiver_id = receiver.id

  if message.save
    # Transmitir a mensagem para o destinatário via ActionCable
    MessagesChannel.broadcast_to(
      receiver,
      { type: "new_message", message: message }
    )

    render json: format_message(message), status: :created
  else
    render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
  end
  end

  private

  def format_message(message)
    {
      id: message.id,
      sender_id: message.sender_id,
      receiver_id: message.receiver_id,
      encrypted_content: message.decrypted_content, # Usa o método que descriptografa
      created_at: message.created_at,
      file_url: message.file.attached? ? url_for(message.file) : nil
    }
  end

  def message_params
    params.permit(:receiver_id, :encrypted_content, :file)
  end

  def authenticate_user
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    decoded = JwtService.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded
    head :unauthorized unless @current_user
  rescue
    head :unauthorized
  end

  def current_user
    @current_user
  end
end
