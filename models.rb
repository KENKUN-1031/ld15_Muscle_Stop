require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_many :users, :through => :friends
    has_many :friends
    has_secure_password
end

class Friends < ActiveRecord::Base
    belongs_to :user
end

class Activity_Logs < ActiveRecord::Base
    has_many :users
end