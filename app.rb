require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'dotenv/load'

require 'open-uri'
require 'net/http'
require 'json'


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
    if session[:user] == nil
        redirect '/signin'
    else
        # p "-------------"
        # p User.find(session[:user]).img
        # p User.find(session[:user]).username
        erb :index 
    end
end


get '/signup' do
    erb :signup
end

get '/signin' do
    erb :signin
end

get '/post' do
    # content_type :json
    # time = JSON.parse(request.body.read)["Time"]
    # { message: "Received time: #{time}" }.to_json
    @time = params[:time]
    date_before = DateTime.now()
    @date = date_before.new_offset('+09:00').strftime('%Y-%m-%d %H:%M:%S')
    
    p"¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥"
    p params[:time]
    p params[:time].class
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

post '/post' do
    # activity_log = Activity_Logs.create(user_id: session[:user], date: Time.now, time: )
    p "-------------------"
    p session[:user]
    activity_log = Activity_Logs.create(user_id: session[:user], date: @date, time: @time, detail: params[:detail])
    redirect '/'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end
