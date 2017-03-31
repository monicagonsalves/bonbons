module StackHelper
	extend ActiveSupport::Concern

	def generate_stack_helper(stack_title, col_class = "col-xs-4")
		@langs = {}
		@flashcards.each do |f| 
			@langs[f.id] = LanguagePair.find(f.language_pair_id)
		end 

		@stack_title = stack_title 
		@col_class = col_class

		render 'stacks/generated_stack'
	end

	def destroy_stack_helper(valid_request)

		if valid_request
			@flashcards.each do |flashcard|
				flashcard.destroy
			end

			respond_to do |format|
	      		format.html { redirect_to :back }
	      		format.json { head :no_content }
	      		format.js   { render 'stacks/destroy'}
	   		end
	   	else 
	   		flash[:error] = "Cannot delete stack."
	   		redirect_to stacks_index_path
	   	end
	end

	def study(stack_title)
		@langs = {}
		@flashcards.each do |f| 
			@langs[f.id] = LanguagePair.find(f.language_pair_id)
		end 

		@stack_title = stack_title 
		@col_class = 'slide'

		render 'stacks/study'
	end
end