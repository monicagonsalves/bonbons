class UserDefinedTagsController < ApplicationController
	def index
		@tags = UserDefinedTag.all
	end

	def new
		@tag = UserDefinedTag.new 
	end

	def create
		self.new
		user_defined_tag_params

		@tag.name = params[:name].downcase.singularize

		if @tag.valid? 
			@tag.save
			flash[:notice] = "Successfully created tag " + params[:name].downcase + "."
		else 
			flash[:notice] = "Failed to create tag " + params[:name].downcase + "."
		end 

		render 'new'
	end

	def edit 
		@tag = UserDefinedTag.find(params[:id])
	end

	def update
		@tag = UserDefinedTag.find(params[:id])
		old_name = @tag.name 
		@tag.name = params[:name].downcase.singularize
		
		if @tag.valid? && !(@tag.name == old_name) 
		    @tag.save
		    flash[:notice] = "Successfully renamed tag " + old_name + " to " + @tag.name
		else 
			flash[:notice] = "Failed to rename tag."
		end
		
		render 'edit'
	end

	def destroy 
		@tag = UserDefinedTag.find(params[:id])

		unless @tag.nil?
			flash[:notice] = "Successfully deleted tag " + @tag.name
			@tag.destroy 
		else
			flash[:notice] = "Tag you are trying to delete does not exist."
		end

		redirect_to user_defined_tags_path
	end 

	private
  		def user_defined_tag_params
    		params.require(:name)
  	    end
end
