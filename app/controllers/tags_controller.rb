class TagsController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@tags = Tag.all(current_user)
	end
end
