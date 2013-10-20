#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require './lib/Filehandler'

class Blog < Sinatra::Base

  POST = Filehandler.new()
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
     selected_post = POST.return_post(params[:number].to_i)
     erb :show_post, :locals =>{:post => selected_post}
  end

  get '/delete/:number' do
     POST.delete_post(params[:number].to_i)
     redirect "/index"
  end

  get '/edit/:number' do
     selected_post = POST.return_post(params[:number].to_i)
     erb :edit_post, :locals =>{:post => selected_post,:number => params[:number].to_i}
  end
  
  post '/edit/edit_post/:number' do
    POST.save_post(params[:title],params[:comment])
    POST.delete_post(params[:number].to_i)
    redirect "/index"
  end

  post '/new_post' do
    POST.save_post(params[:title],params[:comment])
    erb :home
  end
end
