class LanguagePair < ActiveRecord::Base
	has_many :flashcards
	validates :code, uniqueness: true  
	validates :to_lang, uniqueness: {scope: :from_lang, message: "Language pair already exists."}
end
