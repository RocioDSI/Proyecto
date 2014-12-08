require 'sinatra'
require 'sinatra/activerecord'
require './environments'


class Post < ActiveRecord::Base

	get "/posts/:id" do
		@post = Post.find(params[:id])
		@title = @post.title
		erb :"posts/view"
	end

	get "/posts/create" do
		@title = "Create post"
		@post = Post.new
		erb :"posts/create"
	end
end
