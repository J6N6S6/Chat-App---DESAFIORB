module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # Extrai o token do cabeçalho de autorização
      header = request.headers["Authorization"]
      token = header.split(" ").last if header

      # Decodifica o token JWT
      decoded = JwtService.decode(token)
      if decoded
        User.find(decoded[:user_id])
      else
        reject_unauthorized_connection
      end
    rescue
      reject_unauthorized_connection
    end
  end
end
