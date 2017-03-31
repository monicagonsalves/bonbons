class MasterStackController < ApplicationController
	include StackHelper

	def show_stack
		@flashcards = Flashcard.where(user_id: current_user.id)
		stack_title = "All flashcards"
		@study_link = study_master_stack_path()
		generate_stack_helper(stack_title)
	end

	def destroy_stack
		@flashcards = Flashcard.where(user_id: current_user_id)

		destroy_stack_helper(true)
	end 

	def study_stack
		@flashcards = Flashcard.where(user_id: current_user.id)
		stack_title = "All flashcards"
		study(stack_title)
	end
end