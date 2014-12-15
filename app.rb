require 'sinatra'
require 'sinatra/activerecord'
require './environments'
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
  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true
  #validates :autor, presence: true # para cuando estén bien implementados los usuarios
end

#class User
#  include DataMapper::Resource
# 
#  property :id, String
#  property :email, String
#  property :pass, String
#  property :created_at, DateTime
#end

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

# Autenticacion con OAuth
get '/auth/:name/callback' do
  @auth = request.env['omniauth.auth']
  puts "params = #{params}"
  puts "@auth.class = #{@auth.class}"
  puts "@auth info = #{@auth['info']}"
  puts "@auth info class = #{@auth['info'].class}"
  puts "@auth info name = #{@auth['info'].name}"
  puts "@auth info email = #{@auth['info'].email}"
  #puts "-------------@auth----------------------------------"
  #PP.pp @auth
  #puts "*************@auth.methods*****************"
  #PP.pp @auth.methods.sort
  erb :index
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

