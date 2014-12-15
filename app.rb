require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions

class Post < ActiveRecord::Base
  validates :title, presence: true, length: {minimum: 1}
  validates :body, presence: true
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

User.auto_upgrade!

helpers do
  def title
    if @title
      "#{@title}"
    else
      "Introduce tu primera receta de cocina."
    end
  end
end

get "/" do
  @posts = Post.order("created_at DESC")
  @title = "Bienvenido."
  erb :index
end

get "/posts/create" do
  @title = "Comparte tu receta."
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
end

get "/posts/:id" do
  @post = Post.find(params[:id])
  @title = @post.title
  erb :"posts/view"
end

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

get '/users/new' do
  erb :new_user
end

get '/users/:id' do |id|
  @user = User.get(id)
  erb :show_user
end

# Crea el usuario en la base de datos siempre que sea posible
# Si el usuario ya existe, o si el username o password están
# vacíos, devuelve un mensaje de error mediante el flash de
# sinatra

post '/users' do
  if (params[:user][:username].empty?) || (params[:user][:password].empty?)
    flash[:error] = "Error: El nombre de usuario o el password está vacío."
    redirect to ('/users/new')
  elsif User.first(:username => "#{params[:user][:username]}")
    flash[:error] = "El usuario ya existe, elija otro usuario."
    redirect to ('/users/new')
  else
    user = User.create(params[:user])
    flash[:success] = "Su usuario ha sido registrado"
    flash[:login] = "Ha iniciado sesión"
    session["user"] = "#{params[:user][:username]}"
    redirect to("/users/#{user.id}")
  end
end
