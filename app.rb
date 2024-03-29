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
        erb :index 
    end
end


get '/signup' do
    erb :signup
end

get '/profile/search' do
    if User.find_by(username: params[:searchUsername])
        user = User.find_by(username: params[:searchUsername])
        session[:searchId] = user.id
        erb :searchProfile
    else
        redirect '/'
    end
end

get '/profile/search/:id' do
    if User.find_by(username: params[:id])
        user = User.find_by(username: params[:id])
        session[:searchId] = user.id
        erb :searchProfile
    else
        redirect '/'
    end
end

get '/signin' do
    erb :signin
end

get '/post' do
    # content_type :json
    # time = JSON.parse(request.body.read)["Time"]
    # { message: "Received time: #{time}" }.to_json
    session[:time] = params[:time]
    date_before = DateTime.now()
    session[:date] = date_before.new_offset('+09:00').strftime('%Y-%m-%d %H:%M:%S')
    erb :post
end

get '/stopwatch' do
    erb :stopwatch
end

get '/friends' do
    @follow_relations = Friends.where(user_id: session[:user])
    follow_list = []
    Friends.where(user_id: session[:user]).each do |relation|
        p "-----------FriendId----------"
        p relation.user_id
        follow_list << User.find(relation.follower_id)
        @relation_list = follow_list
    end
    erb :friends
end

post '/signup' do
    # ユーザー名がかぶってた時の処理書かないとダメ
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
    activity_log = Activity_Logs.create(user_id: session[:user], date: session[:date], time: session[:time], detail: params[:detail])
    redirect '/'
end

post '/profile/follow/:id' do
    # Friendsの中身がないからloopが回せない
    if Friends.all then
        friends = Friends.create(user_id: session[:user], follower_id: params[:id].to_i)
        redirect '/profile/search/' + User.find(params[:id]).username
    else
        Friends.all.each do |i|
            friends = Friend.create(user_id: session[:user], follower_id: session[:searchUsername])
            p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            p session[:searchId]
            p session[:searchUsername]
            redirect '/profile/search/' + User.find(params[:id]).username
            # if i.user_id == session[:user] && i.follwer_id == session[:searchUsername] then
            #     i.destroy
            #     p "----------insideFollow-----------"
            #     redirect '/profile/search'
            # else
            #     p "---------------elseFollow------------"
            #     friends = Friend.create(user_id: session[:user], follower_id: session[:searchUsername])
            #     redirect '/profile/search'
            # end
        end
    end
end

post '/profile/unfollow/:id' do
    Friends.all.each do |f| 
        if f.user_id = session[:user] && f.follower_id == session[:searchId] then
            f.destroy
        end
        redirect '/profile/search/' + User.find(params[:id]).username
    end
end
# post '/post/delete/:id' do
#   Post.find(params[:id]).destroy
#   redirect '/'

get '/signout' do
    session[:user] = nil
    redirect '/'
end

