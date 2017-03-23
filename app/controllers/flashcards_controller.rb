class FlashcardsController < ApplicationController
	###############################################################################
	def show
		@flashcard = Flashcard.find(params[:id])
		@langs = LanguagePair.find(@flashcard.language_pair_id)
	end 
	###############################################################################
	def edit
		@flashcard = Flashcard.find(params[:id])
		@langs = LanguagePair.find(@flashcard.language_pair_id)
	end 
	###############################################################################
	def update
		@flashcard = Flashcard.find(params[:id])
		@langs = LanguagePair.find(@flashcard.language_pair_id)
		updated_flashcard = false 
		msg = ""

		unless @flashcard.translation == params[:translation]
			@flashcard.translation = params[:translation].downcase
			msg = "updated translation."
			updated_flashcard = true 
		end

		unless params[:image].nil?
			@flashcard.image = params[:image]
			msg = "updated image."
			updated_flashcard = true 
		end

		unless params[:tags].empty?
			# Split string into an array, and strip off the whitespace
			# from each element. Finally, make each tag all lowercase. 
			updated_flashcard = assoc_tags_with_flashcard(params[:tags], @flashcard)
			msg = "associated flashcard with tags " + params[:tags]
		end 

		unless params[:disassoc_tag].nil? 
			tags_to_disassoc = []
			params[:disassoc_tag].each do |tag_name|
				if UserDefinedTag.exists?(name: tag_name)  
					tags_to_disassoc << UserDefinedTag.find_by(name: tag_name)
				end 
			end

			unless tags_to_disassoc.empty?
				@flashcard.user_defined_tags.destroy(tags_to_disassoc)
				msg = "disassociated flashcard with tags " + params[:disassoc_tag].map(&:downcase).join(', ')
				updated_flashcard = true 
			end
		end


		if updated_flashcard
			if @flashcard.valid?
				@flashcard.save
			end
			flash[:notice] = "Successfully " + msg
		else
			flash[:notice] = "Failed to update flashcard either because you did not enter any values to update or because of invalid input."
		end

		render 'edit'
	end
	###############################################################################
	def destroy
		@flashcard = Flashcard.find(params[:id])
		
		unless @flashcard.nil?
			lp = LanguagePair.find(@flashcard.language_pair_id)
			flash[:notice] = "Successfully deleted flashcard that translates " + @flashcard.orig_word.capitalize + " from " + lp.from_lang.capitalize + " to " + lp.to_lang.capitalize
			@flashcard.destroy 
		else 
			flash[:notice] = "The flashcard you are trying to delete doesn't exist!"
		end

		redirect_to flashcards_path
	end 
	###############################################################################
	def new_batch
		@@yandex = YandexDictClient.new
		@supported_langs = @@yandex.get_langs_supported
		@errors = []
	end 
	###############################################################################
	def create_batch
		self.new_batch

		current_batch_num = Flashcard.maximum("batch_num")
		batch_num = if current_batch_num.nil? then 0 else (current_batch_num + 1) end

		if params[:word].nil? then
			@errors << "Must include at least one flashcard!"
		else 
			# First make sure the language pair is supported. Since 
			# we gave the users a list of languages to choose from, then the 
			# language pair should be supported. 
			language_pair = LanguagePair.find_by(to_lang: params[:to_lang].downcase, from_lang: params[:from_lang].downcase)

			if language_pair.nil? then
				@errors << "Cannot translate words from " + params[:from_lang] + " to " + params[:to_lang]
			else 			
				flashcards_temp = []
				
				params[:word].each do |i, word|
					# Generate a new flashcard object
					if word.empty? then
						@errors << "Word fields cannot be empty."
					else
						flashcards_temp << {:flashcard => nil, :tag_names => ""}
						flashcards_temp.last[:flashcard] = Flashcard.new({:language_pair_id => language_pair.id, :orig_word => word, :batch_num => batch_num})

						# Try looking up the word. Can we find a translation?
						lookup_attempt = @@yandex.lookup(params[:from_lang], params[:to_lang], word)
						
						# Now that we've looked up the word, we are going to attempt to fill out 
						# the rest of the fields for the flashcard record. 
						finished_filling_out_flashcard = false 

						if lookup_attempt[:has_error] && lookup_attempt[:error_code ] == 2 then 
							# If you get here, then that means that for some reason we failed to access
							# the yandex api. This should never happen because all the correct information
							# is hardcoded in the YandexDictClient class. 
							@errors << lookup_attempt[:error_msg]
						elsif lookup_attempt[:has_error] && lookup_attempt[:error_code] == 1 then 
							# if you get here, it means that we attempted to find a translation for the
							# word in the Yandex Dictionary API, but we could not even though the 
							# API supports the selected language pair. We're going to create a 
							# dummy flashcard so that you can edit it and put in the correct 
							# data later. Even though we could not translate the word, since 
							# we are creating a dummy flashcard, we are going to claim 
							# that we've finished filling out the flashcard. 
							flashcards_temp.last[:flashcard].translation = "Could not translate word!"
							flashcards_temp.last[:flashcard].gender = "n"
							finished_filling_out_flashcard = true 
						else 
							# If you get here, then everything was fine with the lookup. Now we are 
							# going to attempt to access the pixabay api and find an image. 
							add_data_attempt = flashcards_temp.last[:flashcard].add_data_from_apis(lookup_attempt, @@yandex, params[:from_lang])

							if add_data_attempt[:has_error] then 
								@errors << add_data_attempt[:error_msg]
							else 
								translation = lookup_attempt[:response_data]["def"][0]["tr"][0]

								unless translation["pos"].nil?
									flashcards_temp.last[:tag_names] = flashcards_temp.last[:tag_names] + translation["pos"]
								end 

								finished_filling_out_flashcard = true
							end  
						end
							
							 
						# What about the flashcard we're trying to insert itself? Does that have errors?
						if finished_filling_out_flashcard && flashcards_temp.last[:flashcard].invalid?
							flashcards_temp.last[:flashcard].errors.messages.each do |key, msgs|
								msgs.each do |msg|
									@errors << msg
								end
							end
						end
							
						 
					end

				end	# end loop through words 

			end # end is the language pair valid? 

		end # end has the user entered any words? 
			
		if @errors.empty?
			word_i = 0
			flashcards_temp.each do |f|
				f[:flashcard].save 

				# Add tags.. 
				f[:tag_names] = f[:tag_names] + ',' + params[:batch_tags] + ',' + params[:word_tags][word_i.to_s]

				for i in 1..2
					if f[:tag_names][0] == ',' then 
						f[:tag_names] = f[:tag_names].sub(',','')
					end 
				end

				unless f[:tag_names].empty? then
					assoc_tags_with_flashcard(f[:tag_names], f[:flashcard])
				end 

				word_i = word_i + 1
			end

			flash[:notice] = "Successfully created the batch you are viewing!"
			redirect_to stacks_by_batch_path(batch_num)
		else
			render 'new_batch'
		end
		

	end 
	###############################################################################
	def assoc_tags_with_flashcard(tags, flashcard)
		tag_names = tags.split(',').map(&:strip).map(&:downcase).map(&:singularize)

		tags_to_add = []

		tag_names.each do |tag_name|

			unless UserDefinedTag.exists?(name: tag_name)
			
				tag = UserDefinedTag.create(name: tag_name)
				tags_to_add << tag 
			
			else
				tag = UserDefinedTag.find_by(name: tag_name)

				unless flashcard.user_defined_tags.exists?(name: tag_name)
					tags_to_add << tag 
				end
			
			end
		
		end

		unless tags_to_add.empty?
			flashcard.user_defined_tags << tags_to_add
			return true 
		end

		return false 
	end
end
