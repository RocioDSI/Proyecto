class UsersPass < ActiveRecord::Migration
  def change
  end

  def self.up 
  	create_table :users do |s|
  		s.string :id
  		s.string :username
  		s.string :password
  	end
  end

  def self.down
  	drop_table :users 

end
