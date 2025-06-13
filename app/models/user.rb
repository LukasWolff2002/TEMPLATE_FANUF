class User < ApplicationRecord
    has_secure_password

    before_validation :normalizar_campos

    validates :rut, presence: true, uniqueness: true
    validates :nombre, presence: true
    validates :apellido, presence: true
    validates :password, length: { minimum: 6 }, presence: true

    def nombre_completo
      [nombre, apellido].compact.join(" ")
    end

    private
  
    # Callback que normaliza RUT, nombre, apellido y email
    def normalizar_campos
      normalizar_rut
      normalizar_nombre_apellido
      normalizar_email
    end
  
    # 1. Normalizar RUT
    def normalizar_rut
      return if rut.blank?
  
      # Eliminar todo carácter que no sea dígito ni k/K y convertir a minúscula
      rut_sanitizado = rut.gsub(/[^0-9kK]/, '').downcase
  
      return if rut_sanitizado.blank? # Si no queda nada, no hace nada
  
      cuerpo = rut_sanitizado[0..-2] # Todo menos el último carácter
      dv     = rut_sanitizado[-1]    # Último carácter (puede ser dígito o 'k')
  
      # Formatear el cuerpo con puntos cada 3 dígitos (de derecha a izquierda)
      cuerpo_formateado = cuerpo.reverse.scan(/\d{1,3}/).join('.').reverse
  
      # Asignar en formato "XX.XXX.XXX-DV"
      self.rut = "#{cuerpo_formateado}-#{dv}"
    end
  
    # 2. Normalizar Nombre y Apellido
    #    Primera letra mayúscula, resto minúscula
    def normalizar_nombre_apellido
      if nombre.present?
        # El método .strip elimina espacios extra; .downcase pone en minúsculas;
        # .capitalize pone la primera letra en mayúscula y deja el resto minúsculas
        self.nombre = nombre.strip.downcase.capitalize
      end
  
      if apellido.present?
        self.apellido = apellido.strip.downcase.capitalize
      end
    end
  
    # 3. Normalizar email a todo minúsculas
    def normalizar_email
      self.email = email.strip.downcase if email.present?
    end
  end