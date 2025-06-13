class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  protect_from_forgery with: :exception

  def new
    Rails.logger.info "Renderizando formulario de login"
  end

  def create
    Rails.logger.info "Intentando iniciar sesión con parámetros: #{params.inspect}"

    rut_ingresado = params[:session][:rut].to_s.strip
    password_ingresado = params[:session][:password].to_s.strip

    if rut_ingresado.blank? || password_ingresado.blank?
      flash.now[:alert] = 'El RUT y la contraseña son obligatorios'
      return render :new, status: :unprocessable_entity
    end

    rut_normalizado = normalizar_rut(rut_ingresado)
    user = User.find_by(rut: rut_normalizado)

    if user&.authenticate(password_ingresado)
      if params[:remember_me] == '1'
        cookies.permanent.signed[:user_id] = user.id
        Rails.logger.info "Sesión persistente creada con cookie para el usuario #{user.id}"
      else
        session[:user_id] = user.id
        Rails.logger.info "Sesión temporal iniciada para el usuario #{user.id}"
      end

      redirect_to root_path, notice: 'Inicio de sesión exitoso'
    else
      flash.now[:alert] = "Credenciales incorrectas"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Rails.logger.info "Se recibió la solicitud de cierre de sesión. Session previa: #{session.inspect}"
    session[:user_id] = nil
    cookies.delete(:user_id)
    Rails.logger.info "Se ha cerrado la sesión. Nueva session: #{session.inspect}"
    redirect_to login_path, notice: 'Has cerrado sesión'
  end

  private

  def normalizar_rut(rut)
    rut_sanitizado = rut.gsub(/[^0-9kK]/, '').downcase
    return "" if rut_sanitizado.blank?

    cuerpo = rut_sanitizado[0..-2]
    dv     = rut_sanitizado[-1]
    cuerpo_formateado = cuerpo.reverse.scan(/\d{1,3}/).join('.').reverse

    "#{cuerpo_formateado}-#{dv}"
  end
end