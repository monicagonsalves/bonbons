class UserDefinedTag < ActiveRecord::Base
	has_and_belongs_to_many :flashcards
	validates :name, presence: true, uniqueness: true 
end
