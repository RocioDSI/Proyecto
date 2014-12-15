source 'https://rubygems.org'

#Ruby "2.0.0"


gem "sinatra"
gem 'activerecord'
gem "sinatra-activerecord"
gem 'sinatra-flash'
gem 'sinatra-redirect-with-flash'
gem 'dm-core'
gem 'dm-migrations'
gem 'data_mapper'
gem 'sinatra-contrib'
gem 'rack-cache'

group :development, :test do
   gem 'sqlite3', '1.3.7'
   gem "dm-sqlite-adapter"
   gem "tux"
end

group :production do
   gem "pg"
   gem "dm-postgres-adapter"
end
