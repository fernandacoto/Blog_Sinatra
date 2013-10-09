#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require './lib/Filehandler'

class Blog < Sinatra::Base
  before do
    @links_titles = []
    @posts = Filehandler.new()
    @links_titles = @posts.get_posts_title
  end
  get '/' do
   erb :home
  end

  get '/Index' do
   erb :index_of_posts,:locals =>{:posts => @links_titles}
  end

  get '/New' do
    erb :new_post
  end

  get '/See/:number' do
     @post_number = params[:number].to_i
     @post = Filehandler.new()
     @selected_post = []
     @selected_post = @post.return_post(@post_number)
     erb :show_post, :locals =>{:post => @selected_post}
  end

  get '/Delete/:number' do
     @post_number = params[:number].to_i
     @post = Filehandler.new()
     @post.delete_post(@post_number)
     redirect "/Index"
  end

  get '/Edit/:number' do
     @post_number = params[:number].to_i
     @post = Filehandler.new()
     @selected_post = []
     @selected_post = @post.return_post(@post_number)
     erb :edit_post, :locals =>{:post => @selected_post}
  end
  
  post '/edit_post' do
    erb :home
  end
  post '/new_post' do
    @new_post = Filehandler.new()
    @new_post.save_post(params[:title],params[:comment])
    erb :home
  end
end
