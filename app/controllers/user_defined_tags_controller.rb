class UserDefinedTagsController < ApplicationController
	include StackHelper

	before_action :authenticate_user!

	def new
		@tag = UserDefinedTag.new(user_id: current_user.id)
	end

	def create
		self.new
		user_defined_tag_params

		@tag.name = params[:name].downcase.singularize

		if @tag.valid? 
			@tag.save
			flash[:success] = "Successfully created tag " + params[:name].downcase + "." 
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

				respond_to do |format|
	      			format.html { redirect_to :back }
	      			format.json { head :no_content }
	      			format.js   { render 'user_defined_tags/destroy'}
	   			end
			else
				flash[:error] = "Tag you are trying to delete does not exist."

				redirect_to user_defined_tags_path
			end
		else 
			flash[:error] = "Oops, you cannot delete the tag you selected!"

			redirect_to user_defined_tags_path
		end
	end 

	def show_stack
		tag = UserDefinedTag.find_by(id: params[:id], user_id: current_user.id)
		@flashcards = tag.flashcards

		unless @flashcards.nil?
			stack_title = "All flashcards with tag " + tag.name
			@col_class = "col-xs-4"
			generate_stack_helper(stack_title)
		else
			flash[:error] = "Cannot retrieve stack by tag given."
			redirect_to stacks_index_path
		end 
	end

	def destroy_stack
		tag = UserDefinedTag.find_by(id: params[:id], user_id: current_user.id)
		@flashcards = tag.flashcards


		destroy_stack_helper(!@flashcards.nil?)
	end

	def study_stack
		tag = UserDefinedTag.find_by(id: params[:id], user_id: current_user.id)
		@flashcards = tag.flashcards
		stack_title = " Study all flashcards tagged with " + tag.name.downcase
		study(stack_title)
	end

	private
  		def user_defined_tag_params
    		params.require(:name)
  	    end
end
