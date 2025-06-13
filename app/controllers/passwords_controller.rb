class PasswordsController < ApplicationController
    before_action :require_login
  
    def edit
    end
  
    def update
      if current_user.update(password_params)
        redirect_to root_path, notice: "Contraseña actualizada correctamente."
      else
        flash.now[:alert] = "No se pudo actualizar la contraseña."
        render :edit, status: :unprocessable_entity
      end
    end
  
    private
  
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
  