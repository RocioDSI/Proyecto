require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions
user = Array.new()

class Post < ActiveRecord::Base
  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true
end

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



