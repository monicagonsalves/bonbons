class Batch < ActiveRecord::Base
	has_many :flashcards
	#belongs_to :user
end
