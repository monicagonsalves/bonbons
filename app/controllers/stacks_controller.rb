class StacksController < ApplicationController
	before_action :authenticate_user!
	
	def index 
		@stacks = {}
		
		get_master
		@stacks["master"] = {}
		@stacks["master"][:size] = @flashcards.count
		@stacks["master"][:title] = "Master Stack (all flashcards)"
		@stacks["master"][:link] = stacks_master_path

		# Find all language pair stacks
		language_pairs = LanguagePair.all

		@stacks["lang_pair"] = {}
		language_pairs.each do |lp|
			get_by_langs(lp.code)

			if @flashcards.count > 0 
				@stacks["lang_pair"][lp.id] = {}
				@stacks["lang_pair"][lp.id][:size] = @flashcards.count 
				@stacks["lang_pair"][lp.id][:title] = "All flashcards from " + lp.from_lang.capitalize + " to " + lp.to_lang.capitalize
				@stacks["lang_pair"][lp.id][:link] = stacks_by_langs_path(lp.code.sub('-','_'))
			end
		end

		batches = Flashcard.joins(:batch).where(user_id: current_user.id).uniq.pluck(:batch_id)

		@stacks["batch"] = {}

		batches.each do |i| 
			get_by_batch(i)
			if @flashcards.count > 0 
				@stacks["batch"][i] = {}
				@stacks["batch"][i][:size] = @flashcards.count
				@stacks["batch"][i][:title] = "All flashcards from batch " + i.to_s
				@stacks["batch"][i][:link] = stacks_by_batch_path(i)
			end 
		end

	end
	#----------------------------------------------------------------- Generators
	def master
		get_master
		@delete_path = stacks_master_path
		generate_stack('All flashcards')
	end

	def by_batch 
		successfully_got_flashcards = get_by_batch(params[:id])

		if successfully_got_flashcards
			@delete_path = stacks_by_batch_path(params[:id])
			stack_title = 'All flashcards from batch ' + params[:id]
			generate_stack(stack_title)
		else 
			flash[:notice] = "Cannot retrieve stack by batch number given."
			redirect_to stacks_index_path
		end
	end 

	def by_langs
		successfully_got_flashcards = get_by_langs(params[:id])

		if successfully_got_flashcards 
			@delete_path = stacks_by_langs_path(@language_pair.code.sub('-','_'))
			stack_title = 'All flashcards from ' + @language_pair.from_lang.capitalize + " to " + @language_pair.to_lang.capitalize
			generate_stack(stack_title)
		else 
			flash[:notice] = "Cannot retrieve stack by language pair given."
			redirect_to stacks_index_path
		end  
		
	end 

	def by_user_defined_tag
		successfully_got_flashcards = get_by_user_defined_tag(params[:id])

		if successfully_got_flashcards 
			@delete_path = stacks_by_user_defined_tag_path(params[:id])
			stack_title = "All flashcards with tag " + @tag.name
			generate_stack(stack_title)
		else 
			flash[:notice] = "Cannot retrieve stack by tag given."
			redirect_to stacks_index_path
		end 
	end

	#---------------------------------------------------------------- Destructors	
	def destroy_master
		get_master
		@count = @flashcards.count 
		@stack_title = "the master (all flashcards) " 
		destroy_stack
	end 

	def destroy_by_langs
		successfully_got_flashcards = get_by_langs(params[:id])

		if successfully_got_flashcards 
			@count = @flashcards.count 
			@stack_title =  @language_pair.from_lang.capitalize + " to " + @language_pair.to_lang.capitalize
			destroy_stack
		else 
			flash[:notice] = "Cannot delete stack."
			redirect_to stacks_index_path
		end
	end

	def destroy_by_batch
		successfully_got_flashcards = get_by_batch(params[:id])

		if successfully_got_flashcards
			@count = @flashcards.count 
			@stack_title = "batch " + params[:id]
			destroy_stack
		else 
			flash[:notice] = "Cannot delete stack."
			redirect_to stacks_index_path
		end 

	end

	def destroy_by_user_defined_tag 
		successfully_got_flashcards = get_by_user_defined_tag(params[:id])

		if successfully_got_flashcards 
			@count = @flashcards.count 
			@stack_title = " tag " + @tag.name 
			destroy_stack
		else 
			flash[:notice] = "Cannot delete stack."
			redirect_to stacks_index_path
		end
	end

	#-----------------------------------------------------------------Helpers
	def get_by_langs(id)
		lang_code = id.sub('_', '-')
		@language_pair = LanguagePair.find_by(code: lang_code)

		unless @language_pair.nil?
			@flashcards = Flashcard.where(language_pair_id: @language_pair.id, user_id: current_user.id)
			return true 	
		end

		return false 
	end

	def get_by_batch(id)
		temp = Flashcard.where(batch_id: id, user_id: current_user.id)

		unless temp.empty?
			@flashcards = temp 
			return true
		end

		return false 
	end

	def get_master
		@flashcards = Flashcard.where(user_id: current_user.id)
	end

	def get_by_user_defined_tag(id)
		@tag = UserDefinedTag.find_by(id: id, user_id: current_user.id)

		unless @tag.nil?
			@flashcards = @tag.flashcards
			return true
		end

		return false 
	end

	def destroy_stack
		@flashcards.each do |flashcard|
			flashcard.destroy
		end

		render 'deleted_stack'
	end

	def generate_stack(stack_title)
		@langs = {}
		@flashcards.each do |f| 
			@langs[f.id] = LanguagePair.find(f.language_pair_id)
		end 

		@stack_title = stack_title 
		render 'generated_stack'
	end 
end
