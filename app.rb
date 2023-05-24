require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'dotenv/load'


enable :sessions

before do
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name = ENV["CLOUD_NAME"]
        config.api_key = ENV["CLOUDINARY_API_KEY"]
        config.api_secret = ENV["CLOUDINARY_API_SECRET"]
    end
end


get '/' do
    erb :index
end


get '/signup' do
    erb :signup
end

get '/signin' do
    erb :signin
end

get '/post' do
    erb :post
end

get '/stopwatch' do
    erb :stopwatch
end

post '/signup' do
    img_url = ''
    if params[:file]
        img = params[:file]
        tempfile = img[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        img_url = upload['url']
    end
    user = User.create(username: params[:username], password: params[:password], password_confirmation: params[:password_confirmation], img: img_url)
    session[:user] = user.id
    redirect '/'
end

post '/signin' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
       session[:user] = user.id
    end
    redirect '/'
end