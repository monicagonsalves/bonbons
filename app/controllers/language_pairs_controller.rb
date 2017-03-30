class LanguagePairsController < ApplicationController
	include StackHelper

	def show_stack
		lang_code = params[:id].sub('_', '-')
		language_pair = LanguagePair.find_by(code: lang_code)

		@flashcards = Flashcard.where(language_pair_id: language_pair.id, user_id: current_user.id)

		unless @flashcards.nil?
			stack_title = 'All flashcards from ' + language_pair.from_lang.capitalize + " to " + language_pair.to_lang.capitalize
		    @col_class = "col-xs-4"
		    generate_stack_helper(stack_title)
		else
			flash[:error] =  "Cannot retrieve stack by language pair given."
			redirect_to stacks_index_path
		end
	end

	def destroy_stack

		lang_code = params[:id].sub('_', '-')
		language_pair = LanguagePair.find_by(code: lang_code)

		@flashcards = Flashcard.where(language_pair_id: language_pair.id, user_id: current_user.id)

		destroy_stack_helper(!@flashcards.nil?)
	end

	def study_stack

		lang_code = params[:id].sub('_', '-')
		lp = LanguagePair.find_by(code: lang_code)

		@flashcards = Flashcard.where(language_pair_id: lp.id, user_id: current_user.id)
		stack_title = "Study all flashcards from " + lp.from_lang.capitalize + " to " + lp.to_lang.capitalize
		study(stack_title)
	end
end