require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'dm-core'
require 'dm-migrations'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

# Para OAuth
require 'bundler/setup'
require 'sinatra/reloader' if development?
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'pry'
require 'erubis'
require 'pp'

# Para usuarios
require 'data_mapper'
DataMapper.setup(:default, 'sqlite::memory:')

# Para OAuth
use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['identifier'], config['secret']
end

enable :sessions
set :session_secret, '*&(^#234a)'
user = Array.new()

class Post < ActiveRecord::Base
  validates :title, presence: true, length: {minimum: 1}
  validates :body, presence: true
  #validates :autor, presence: true # para cuando estén bien implementados los usuarios
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :password, String
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

DataMapper.finalize

helpers do
  def title
    if @title
      "#{@title}"
    else
      "ReceBlario"
    end
  end
end

helpers do
  include Rack::Utils
end

# Obtiene todos los posts
get "/" do
  @posts = Post.order("created_at DESC")
  @title = "ReceBlario"
  erb :index
end

get "/login" do
  erb :login
end

get "/index" do
  erb :login
end

# Autenticacion con OAuth
get '/auth/:name/callback' do
  @auth = request.env['omniauth.auth']
  session["user"] = "#{params[:user][:username]}"
  @user['username'] = @auth['info'].first_name
  puts session["user"]
  erb :recetas
end

post "/login" do
  #if (user.include?(params[:username]))
  #  redirect '/recetas'
  #else
  #  name = params[:username]
  #  session[:name] = name
  #  user << name
  #  puts user
  #  erb :recetas
  #end
  redirect "/recetas"
end

get "/recetas" do
  @posts = Post.order("created_at DESC")
  #@title = ReceBlario
  erb :recetas
end

# Crear nuevo post
get "/posts/create" do
  @title = "Comparte una nueva receta"
  @post = Post.new
  erb :create
end

post "/posts" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}", :notice => 'Tu receta se ha publicado satisfactoriamente.'
  else
    redirect "posts/create", :error => 'Error al publicar, intentelo de nuevo.'
  end
redirect "posts/recetas"
end

# Ver post
get "/posts/:id" do
 @post = Post.find(params[:id])
 @title = @post.title
 erb :view
end

# Editar post
get "/posts/:id/edit" do
  @post = Post.find(params[:id])
  @title = "Edite su receta."
  erb :edit
end

put "/posts/:id" do
  @post = Post.find(params[:id])
  @post.update(params[:post])
  redirect "/posts/#{@post.id}"
end

get '/login' do
  erb :recetas
end

get '/users/new' do
  erb :login
end

get '/users/:id' do |id|
  @user = User.get(id)
  erb :recetas
end

# Crea el usuario en la base de datos siempre que sea posible
# Si el usuario ya existe, o si el username o password están
# vacíos, devuelve un mensaje de error mediante el flash de
# sinatra

get '/login' do
  erb :login
end
# Realiza el login comprobando que el nombre de usuario y contraseña
# introducidos son los correctos. Si el usuario y contraseña no están
# rellenos, o no han sido creados en la base de datos, devuelve error
# mediante el flash de sinatra; si no es así, crea la sesión
# agregando el atributo user en el hash de session, con el username
# del usuario que ha realizado el login
post '/login' do
  if (params[:user][:username].empty?) || (params[:user][:password].empty?)
    flash[:error] = "Error: The user or the password field is empty"
    redirect to ('/login')
  elsif User.first(:username => "#{params[:user][:username]}", :password => "#{params[:user][:password]}")
    flash[:login] = "Login successfully"
    session["user"] = "#{params[:user][:username]}"
    puts session["user"]
    redirect to ('/')
  else
    flash[:error] = "The user doesn't exist or the password is invalid"
    redirect to("/login")
  end
end
# Realiza el logout del usuario, eliminando el atributo user
# de la session
get '/logout' do
  session.delete("user")
  flash[:logout] = "Logout successfully"
  redirect to ('/')
end
