class FilesController < ApplicationController
  before_action :authenticate_user

  def show
    message = Message.find(params[:id])
    if message.sender == current_user || message.receiver == current_user
      if message.file.attached?
        send_data message.file.download, filename: message.file.filename.to_s, type: message.file.content_type, disposition: "inline"
      else
        render json: { error: "Arquivo não encontrado" }, status: :not_found
      end
    else
      head :forbidden
    end
  end

  private

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
