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
			flash[:success] = "Successfully created tag " + params[:name].downcase + "." + " (current, tag) = (" + current_user.id.to_s + ", " + @tag.user_id.to_s + ")"  
		else 
			flash[:error] = "Failed to create tag " + params[:name].downcase + "."
		end 

		render 'new'
	end

	def edit 
		@tag = UserDefinedTag.find_by(id: params[:id])

		unless @tag.nil?
			unless @tag.user_id == current_user.id 
				flash[:error] = "Oops, you cannot edit the tag you selected." 
				@tag = nil 

				redirect_to user_defined_tags_path 
				return 
			end 
		else 
			flash[:error] = "Oops the tag you are trying to edit does not exist."
			redirect_to user_defined_tags_path
		end
	end

	def update
		@tag = UserDefinedTag.find_by(id: params[:id])

		unless @tag.nil?
			old_name = @tag.name 
			@tag.name = params[:name].downcase.singularize
			
			if @tag.user_id == current_user.id 
				if @tag.valid? && !(@tag.name == old_name) 
			    	@tag.save
			    	flash[:success] = "Successfully renamed tag " + old_name + " to " + @tag.name
				else 
					flash[:error] = "Failed to rename tag."
				end
			
				render 'edit'
			else 
				flash[:error] = "Oops, you cannot edit the tag you selected!"
				redirect_to user_defined_tags_path
			end
		else 
			flash[:error] = "Oops the tag you are trying to edit does not exist."
		end
	end

	def destroy 
		@tag = UserDefinedTag.find_by(id: params[:id])

		if @tag.user_id == current_user.id
			unless @tag.nil?
				flash[:success] = "Successfully deleted tag " + @tag.name
				@tag.destroy 
			else
				flash[:error] = "Tag you are trying to delete does not exist."
			end
		else 
			flash[:error] = "Oops, you cannot delete the tag you selected!"
		end

		redirect_to user_defined_tags_path
	end 

	private
  		def user_defined_tag_params
    		params.require(:name)
  	    end
end
