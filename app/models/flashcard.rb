class Flashcard < ActiveRecord::Base
	#----------------------------------------------------------------------#
	# Following uses the paperclip gem to add a file to the database
	#----------------------------------------------------------------------#
	has_attached_file :image, :default_url => "/images/original/flashcards/missing_flashcard_1.jpg"
	has_attached_file :audio
	attr_reader :image_remote_url
	attr_reader :audio_remote_url

	#-------------------------Validations----------------------------------#
	# To use paperclip gem, you need to verify that the incomming file has
	# the content type you expect. 
	#----------------------------------------------------------------------#
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
	validates :orig_word, uniqueness: { scope: :language_pair_id, message: "Flashcard already exists."}

	#-------------------------Associations---------------------------------#
	belongs_to :language_pair
	has_and_belongs_to_many :user_defined_tags
	has_and_belongs_to_many :stacks

def image_remote_url=(url_value)
    self.image = URI.parse(url_value)
    # Assuming url_value is http://example.com/photos/face.png
    # image_file_name == "face.png"
    # image_content_type == "image/png"
    @image_remote_url = url_value
  end

  def audio_remote_url=(url_value)
    self.audio = URI.parse(url_value)
    # Assuming url_value is http://example.com/photos/talk.mp3
    # audio_file_name == "talk.mp3"
    # audio_content_type == "audio/mp3"
    @audio_remote_url = url_value
  end

  def add_data_from_apis(query_results, yandex, from_lang)
  	data = query_results[:response_data]["def"][0]
  	self.gender = if data["tr"][0]["gen"].nil? then "n" else data["tr"][0]["gen"] end
  	self.translation = data["tr"][0]["text"].downcase

  	pixabay = PixabayClient.new

  	#english_translation_of_word = yandex.get_english_trans(from_lang, self.orig_word)
  	lang_code = yandex.get_lang_code(from_lang)

  	img_query = pixabay.find_image(self.orig_word, lang_code)


  	if img_query[:has_error]
  		return {:has_error => true, :error_msg => img_query[:error_msg]}
  	end
  	
  	self.image_remote_url = img_query[:response]
  	

  	return {:has_error => false}
  	
  end
end
