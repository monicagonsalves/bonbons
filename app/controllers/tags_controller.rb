class TagsController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@tags = Tag.all(current_user)
	end

	def find 
		@tags = Tag.all(current_user)

		unless params[:filter_rules].nil?

			if params[:filter_rules].include?('user_defined_only')
			    @tags = @tags.select { |tag| tag.category == 1 }
			end

			# Remove empty stacks, if necessary
			if params[:filter_rules].include?('remove_empty')
				@tags = @tags.select {|tag| tag.flashcards.size > 0 }
			end
		
		end

		unless params[:srch_term].empty?
			terms = params[:srch_term].split(',').map(&:strip).map(&:downcase)		

			@tags = @tags.select{ |tag| terms.any?{|term| tag.name.downcase.include?(term)} }
		end
		
		respond_to do |format|
	      	format.js
	   	end

	end 

	def delete_all
		tags = UserDefinedTag.where(user_id: current_user.id)

		tags.each do |tag|
			if tag.flashcards.size == 0 
				tag.destroy
			end
		end

		respond_to do |format|
	      	format.html { redirect_to :back }
	      	format.json { head :no_content }
	      	format.js   { render 'delete_all'}
	   	end
	end
end
