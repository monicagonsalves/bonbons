class StacksController < ApplicationController
	include Stackable

	before_action :authenticate_user!
	
	def index 
		@stacks = {}
		
		@flashcards = get_master
		@stacks["master"] = {}
		@stacks["master"][:size] = @flashcards.count
		@stacks["master"][:title] = "Master Stack (all flashcards)"
		@stacks["master"][:link] = stacks_master_path

		# Find all language pair stacks
		language_pairs = LanguagePair.all

		@stacks["lang_pair"] = {}
		language_pairs.each do |lp|
			result = get_by_langs(lp.code)
			@flashcards = result[:flashcards]

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

			result = get_by_batch(i)
			@flashcards = result[:flashcards]
			
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
		@flashcards = get_master
		@delete_path = stacks_master_path
		generate_stack('All flashcards')
	end

	def by_batch 
		result = get_by_batch(params[:id])

		if result[:success]
			@flashcards = result[:flashcards]
			@delete_path = stacks_by_batch_path(params[:id])
			stack_title = 'All flashcards from batch ' + params[:id]
			generate_stack(stack_title)
		else 
			flash[:error] = "Cannot retrieve stack by batch number given."
			redirect_to stacks_index_path
		end
	end 

	def by_langs
		result = get_by_langs(params[:id])

		if result[:success] 
			@flashcards = result[:flashcards]
			@language_pair = result[:language_pair]

			@delete_path = stacks_by_langs_path(@language_pair.code.sub('-','_'))
			stack_title = 'All flashcards from ' + @language_pair.from_lang.capitalize + " to " + @language_pair.to_lang.capitalize
			
			generate_stack(stack_title)
		else 
			flash[:error] = "Cannot retrieve stack by language pair given."
			redirect_to stacks_index_path
		end  
		
	end 

	def by_user_defined_tag
		result = get_by_user_defined_tag(params[:id])

		if result[:success] 
			@flashcards = result[:flashcards]
			@tag = result[:tag]

			@delete_path = stacks_by_user_defined_tag_path(params[:id])
			stack_title = "All flashcards with tag " + @tag.name
			generate_stack(stack_title)
		else 
			flash[:error] = "Cannot retrieve stack by tag given."
			redirect_to stacks_index_path
		end 
	end

	#---------------------------------------------------------------- Destructors	
	def destroy_master
		@flashcards = get_master
		@count = @flashcards.count 
		@stack_title = "the master (all flashcards) " 
		destroy_stack
	end 

	def destroy_by_langs
		result = get_by_langs(params[:id])

		if result[:success] 
			@flashcards = result[:flashcards]
			@language_pair = result[:language_pair]

			@count = @flashcards.count 
			@stack_title =  @language_pair.from_lang.capitalize + " to " + @language_pair.to_lang.capitalize
			destroy_stack
		else 
			flash[:error] = "Cannot delete stack."
			redirect_to stacks_index_path
		end
	end

	def destroy_by_batch
		result = get_by_batch(params[:id])

		if result[:success]
			@flashcards = result[:flashcards]

			@count = @flashcards.count 
			@stack_title = "batch " + params[:id]
			destroy_stack
		else 
			flash[:error] = "Cannot delete stack."
			redirect_to stacks_index_path
		end 

	end

	def destroy_by_user_defined_tag 
		result = get_by_user_defined_tag(params[:id])

		if result[:success] 
			@flashcards = result[:flashcards]
			@tag = result[:tag]

			@count = @flashcards.count 
			@stack_title = " tag " + @tag.name 
			destroy_stack
		else 
			flash[:error] = "Cannot delete stack."
			redirect_to stacks_index_path
		end
	end

	#-----------------------------------------------------------------Helpers
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
