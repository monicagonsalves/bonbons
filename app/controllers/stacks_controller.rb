class StacksController < ApplicationController
	include Stackable

	before_action :authenticate_user!
	
	def index 
		@stacks = auto_generated_stacks

		make_study_paths
	end

	def find
		@stacks = auto_generated_stacks

		unless params[:filter_rules].nil?

			unless (params[:filter_rules] & ["1","2", "3"]).empty?
				@stacks = @stacks.select {|stack| params[:filter_rules].include?(stack.category.to_s) }
			end

			# Remove empty stacks, if necessary
			if params[:filter_rules].include?('remove_empty')
				@stacks = @stacks.select {|stack| stack.flashcards.size > 0 }
			end
		
		end

		unless params[:srch_term].empty?
			terms = params[:srch_term].split(',').map(&:strip).map(&:downcase)		

			@stacks = @stacks.select{ |stack| terms.any?{|term| stack.name.downcase.include?(term)} }
		end

		make_study_paths

		respond_to do |format|
	      	format.js {render layout: false}
	   	end

	end
	#---------------------------------------------------------------- Helpers	

	def auto_generated_stacks
		#---------------------------------------------------------------#
		# Categories: 
		#    5 => Custom
		#    4 => Master
		#    3 => Language Pair
		#    2 => Batch
		#    1 => User Defined Tags
		#---------------------------------------------------------------#

		stacks = []
		
		master_stack = Stack.new(name: "Master (all flashcards)", category: 4, is_public: 0, path_to: flashcards_path)
		master_stack.flashcards << get_master 

		stacks << master_stack 

		tags = Tag.all(current_user)

		stacks = stacks + Tag.tags_to_stacks(tags)

		return stacks
	end

	def make_study_paths

		@study_paths = []
		
		@stacks.each do |stack|

			if stack.category == 1 

				tag = UserDefinedTag.find_by(user_id: current_user.id, name: stack.name)
				@study_paths << study_stack_by_user_defined_tag_path(tag.id)

			elsif stack.category == 2

				batch = stack.name.sub('Batch', '').strip()
				@study_paths << study_stack_by_batch_path(batch)

			elsif stack.category == 3

				langs = stack.name.sub('to', ',').split(',').map(&:strip).map(&:downcase)
				lp = LanguagePair.find_by(from_lang: langs[0], to_lang: langs[1])
				@study_paths << study_stack_by_langs_path(lp.code.sub('-','_'))
			
			elsif  stack.category == 4
			
				@study_paths << study_master_stack_path
			
			end
		end

	end
end
