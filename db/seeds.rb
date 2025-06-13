# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.delete_all

User.create!(
  nombre: "Lukas",
  apellido: "Wolff",
  rut: "12.345.678-9",
  email: "lukas@example.com",
  cargo: "admin",
  password: "12345678",  # será encriptado automáticamente
  password_confirmation: "12345678"
)

User.create!(
  nombre: "Ana",
  apellido: "Pérez",
  rut: "98.765.432-1",
  email: "ana@example.com",
  cargo: "jefe_volante",
  password: "segura456",
  password_confirmation: "segura456"
)

User.create!(
  nombre: "Carlos",
  apellido: "Díaz",
  rut: "11.222.333-4",
  email: "carlos@example.com",
  cargo: "seleccionador",
  password: "clave789",
  password_confirmation: "clave789"
)

puts "Datos de prueba creados correctamente"
