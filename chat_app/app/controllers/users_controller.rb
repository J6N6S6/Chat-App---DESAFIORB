class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: { message: "Usuário criado com sucesso!" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

    def find_by_email
    user = User.find_by(email: params[:email])
    if user
      render json: { id: user.id, name: user.name }
    else
      render json: { error: "Usuário não encontrado" }, status: :not_found
    end
  end

  def show
    user = User.find_by(id: params[:id])
    if user
      render json: { id: user.id, name: user.name }
    else
      render json: { error: "Usuário não encontrado" }, status: :not_found
    end
  end
end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
