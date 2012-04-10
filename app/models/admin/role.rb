class Admin::Role < ActiveRecord::Base
	has_many :users
end
