require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions

class Post < ActiveRecord::Base
  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true
end

#Get todos los post
get "/" do
  @posts = Post.order("created_at DESC")
  @title = "Bienvenido."
  erb :index
end

helpers do
  def title
    if @title
      "#{@title}"
    else
      "Introduce tu primera receta de cocina."
    end
  end
end

#Crear nuevo post
get "/posts/create" do
  @title = "Comparte tu receta."
  @post = Post.new
  erb :create
end

put "/posts/:id" do
  @post = Post.find(params[:id])
  @post.update(params[:post])
  redirect "/posts/#{@post.id}"
end

#Ver post
get "/posts/:id" do
 @post = Post.find(params[:id])
 @title = @post.title
 erb :view
end

get "/posts/:id/edit" do
  @post = Post.find(params[:id])
  @title = "Edite su receta."
  erb :edit
end

post "/posts" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}", :notice => 'Tu receta se ha publicado satisfactoriamente.'
  else
    redirect "posts/create", :error => 'Error al publicar, intentelo de nuevo.'
  end
end


