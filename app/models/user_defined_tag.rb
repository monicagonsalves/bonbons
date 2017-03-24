class UserDefinedTag < ActiveRecord::Base
	has_and_belongs_to_many :flashcards
	belongs_to :user 
	validates :name, uniqueness: { scope: :user_id, message: "Tag already exists."}
end
