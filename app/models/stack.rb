class Stack < ActiveRecord::Base
	has_and_belongs_to_many :flashcards
end
