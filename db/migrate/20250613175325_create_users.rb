class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :nombre
      t.string :apellido
      t.string :rut, null: false
      t.string :email, null: false
      t.string :cargo
      t.string :password_digest, null: false
      t.timestamps
    end

    add_index :users, :cargo
    add_index :users, :rut  # También es buena práctica indexar el rut ya que se usará para login
  end
end