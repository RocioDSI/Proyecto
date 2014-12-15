require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'dm-core'
require 'dm-migrations'
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
  alias_method :h, :escape_html
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

get '/users/new' do
  erb :signup
end

get '/users/:id' do |id|
  @user = User.get(id)
  erb :signin
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
    redirect to("/recetas")
  end
end

