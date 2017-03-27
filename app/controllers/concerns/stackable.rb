module Stackable
	extend ActiveSupport::Concern

	def get_master
		flashcards = Flashcard.where(user_id: current_user.id)
		return flashcards
	end

	def get_by_langs(id)
		lang_code = id.sub('_', '-')
		language_pair = LanguagePair.find_by(code: lang_code)

		unless language_pair.nil?
			flashcards = Flashcard.where(language_pair_id: language_pair.id, user_id: current_user.id)
			return {:success => true, :flashcards => flashcards, :language_pair => language_pair} 	
		end

		return {:success => false}
	end 

	def get_by_batch(id)
		temp = Flashcard.where(batch_id: id, user_id: current_user.id)

		unless temp.empty?
			flashcards = temp 
			return {:success => true, :flashcards => flashcards} 
		end

		return {:success => false} 
	end

	def get_by_user_defined_tag(id)
		tag = UserDefinedTag.find_by(id: id, user_id: current_user.id)

		unless tag.nil?
			flashcards = tag.flashcards
			return {:success => true, :flashcards => flashcards, :tag => tag} 
		end

		return {:success => false}  
	end
end