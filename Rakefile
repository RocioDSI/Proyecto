require './app'
require 'sinatra/activerecord/rake'
task :default => :server

desc "run server"
task :server do
  sh "rackup"
end

desc "tests"
task :test do
	sh "ruby test/test.rb"
end

desc "Visit the GitHub repo page"
task :open do
  sh "open https://github.com/RocioDSI/Proyecto"
end