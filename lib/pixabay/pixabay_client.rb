class PixabayClient
	@@api_key = YAML.load_file(Rails.root + "lib/pixabay/pixabay_client_setup.yaml")["api_key"]
	@@base_url = "https://pixabay.com/api/?key="
	#############################################################################################################
	def find_images(str, str_lang)
		url = @@base_url + @@api_key + "&q=" + Addressable::URI.encode(str) + "&lang=" + str_lang

		http_response = open(url)

		if http_response.status[0] == "200"
			response_data = JSON::parse(http_response.read)
			return {:has_error => false, :response_data => response_data}
		end 

		return {:has_error => true, :error_msg => "Sorry, failed to access Pixabay API."}
	end
	#############################################################################################################
	def find_image(str, str_lang = "en", get_random = false)
		result = find_images(str, str_lang)

		if result[:has_error]
			return result 
		end

		total_hits = result[:response_data]["totalHits"]

		if total_hits == 0
			return {:has_error => true, :error_msg => "Sorry, we could not find any images matching your query."}
		end

		which_image = if get_random then rand(20) else 0 end

		return {:has_error => false, :response => result[:response_data]["hits"][which_image]["webformatURL"] }
	end
end