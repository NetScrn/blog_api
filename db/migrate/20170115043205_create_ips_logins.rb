class CreateIpsLogins < ActiveRecord::Migration[5.0]
  def change
    create_table :ips_logins do |t|
      t.string :ip
      t.string :login
      t.references :post, foreign_key: true
    end
  end
end
