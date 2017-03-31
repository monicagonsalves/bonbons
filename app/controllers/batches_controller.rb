class BatchesController < ApplicationController
	include StackHelper

	def show_stack
		@flashcards = Flashcard.where(batch_id: params[:id], user_id: current_user.id)

		unless @flashcards.nil?
			stack_title = "All flashcards " + " from batch " + params[:id]
			@study_link = study_stack_by_batch_path(params[:id])
			generate_stack_helper(stack_title)
		else
			flash[:error] = "Cannot retrieve stack by batch number given."
			redirect_to stacks_index_path
		end
	end

	def destroy_stack
		@flashcards = Flashcard.where(batch_id: params[:id], user_id: current_user.id)

		destroy_stack_helper(!@flashcards.nil?)
	end

	def study_stack
		@flashcards = Flashcard.where(batch_id: params[:id], user_id: current_user.id)
		stack_title = "Study all flashcards from batch " + params[:id]
		study(stack_title)
	end
end