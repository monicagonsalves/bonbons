class StacksController < ApplicationController
	include Stackable

	before_action :authenticate_user!
	
	def index 
		#---------------------------------------------------------------#
		# Categories: 
		#    5 => Custom
		#    4 => Master
		#    3 => Language Pair
		#    2 => Batch
		#    1 => User Defined Tags
		#---------------------------------------------------------------#
		auto_generated_stacks
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

	def auto_generated_stacks
		@stacks = []
		
		master_stack = Stack.new(name: "Master (all flashcards)", category: 4)
		master_stack.flashcards << get_master 

		@stacks << master_stack 

		tags = Tag.all(current_user)

		@stacks = @stacks + Tag.tags_to_stacks(tags)

		@paths = []

		@stacks.each do |stack|
			if stack.category == 1
				tag = UserDefinedTag.find_by(user_id: current_user.id, name: stack.name.downcase)
				@paths << stacks_by_user_defined_tag_path(tag.id)
			elsif stack.category == 2 
				@paths << stacks_by_batch_path(stack.flashcards.first.batch_id)
			elsif stack.category == 3 
				langs = stack.name.sub(' to ', ',').split(',').map(&:strip).map(&:downcase)
				lp = LanguagePair.find_by(from_lang: langs[0], to_lang: langs[1])

				@paths << stacks_by_langs_path(lp.code.sub('-','_'))
			elsif stack.category == 4
				@paths << flashcards_path 
			end 
		end
	end
end
