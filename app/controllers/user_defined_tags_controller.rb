class UserDefinedTagsController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@tags = UserDefinedTag.where(user_id: current_user.id)
	end

	def new
		@tag = UserDefinedTag.new(user_id: current_user.id)
	end

	def create
		self.new
		user_defined_tag_params

		@tag.name = params[:name].downcase.singularize

		if @tag.valid? 
			@tag.save
			flash[:notice] = "Successfully created tag " + params[:name].downcase + "." + " (current, tag) = (" + current_user.id.to_s + ", " + @tag.user_id.to_s + ")"  
		else 
			flash[:notice] = "Failed to create tag " + params[:name].downcase + "."
		end 

		render 'new'
	end

	def edit 
		@tag = UserDefinedTag.find(params[:id])

		unless @tag.user_id == current_user.id 
			flash[:notice] = "Oops, you cannot edit the tag you selected." 
			@tag = nil 

			redirect_to user_defined_tags_path 
			return 
		end  
	end

	def update
		@tag = UserDefinedTag.find(params[:id])
		old_name = @tag.name 
		@tag.name = params[:name].downcase.singularize
		
		if @tag.user_id == current_user.id 
			if @tag.valid? && !(@tag.name == old_name) 
		    	@tag.save
		    	flash[:notice] = "Successfully renamed tag " + old_name + " to " + @tag.name
			else 
				flash[:notice] = "Failed to rename tag."
			end
		
			render 'edit'
		else 
			flash[:notice] = "Oops, you cannot edit the tag you selected!"
			redirect_to user_defined_tags_path
		end
	end

	def destroy 
		@tag = UserDefinedTag.find(params[:id])

		if @tag.user_id == current_user.id
			unless @tag.nil?
				flash[:notice] = "Successfully deleted tag " + @tag.name
				@tag.destroy 
			else
				flash[:notice] = "Tag you are trying to delete does not exist."
			end
		else 
			flash[:notice] = "Oops, you cannot delete the tag you selected!"
		end

		redirect_to user_defined_tags_path
	end 

	private
  		def user_defined_tag_params
    		params.require(:name)
  	    end
end
