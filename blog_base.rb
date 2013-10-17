#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require './lib/Filehandler'

class Blog < Sinatra::Base

  before do
    @links_titles = []
    posts = Filehandler.new()
    @links_titles = posts.get_posts_title
  end

  get '/' do
   erb :home
  end

  get '/index' do
   erb :index_of_posts,:locals =>{:posts => @links_titles}
  end

  get '/new' do
    erb :new_post
  end

  get '/show/:number' do
     post_number = params[:number].to_i
     post = Filehandler.new()
     selected_post = []
     selected_post = post.return_post(post_number)
     erb :show_post, :locals =>{:post => selected_post}
  end

  get '/delete/:number' do
     post_number = params[:number].to_i
     post = Filehandler.new()
     post.delete_post(post_number)
     redirect "/index"
  end

  get '/edit/:number' do
     post_number = params[:number].to_i
     post = Filehandler.new()
     selected_post = []
     selected_post = post.return_post(post_number)
     erb :edit_post, :locals =>{:post => selected_post,:number => post_number}
  end
  
  post '/edit/edit_post/:number' do
    new_post = Filehandler.new()
    new_post.save_post(params[:title],params[:comment])
    new_post.delete_post(params[:number].to_i)
    redirect "/index"
  end

  post '/new_post' do
    new_post = Filehandler.new()
    new_post.save_post(params[:title],params[:comment])
    erb :home
  end
end
