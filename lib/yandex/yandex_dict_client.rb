class YandexDictClient
	@@api_key = YAML.load_file(Rails.root + "lib/yandex/yandex_dict_client_setup.yaml")["api_key"]
	@@langs_supported = {
		"russian" => "ru",
		"english" => "en",
		#"spanish" => "es",
		"french" => "fr",
		"italian" => "it",
		"german" => "de",
		"turkish" => "tr", 
		"portugese" => "pt",
		"danish" => "da",
		"finnish" => "fi"
	}
	def get_lang_code(lang)
		return @@langs_supported[lang.downcase]
	end
	#################################################
	def get_langs_supported_as_hash
		return @@langs_supported
	end
	#################################################
	def get_pairs_from_yandex
		base_url = "https://dictionary.yandex.net/api/v1/dicservice.json/getLangs?key="
		query_url = base_url + @@api_key 
		response_data = JSON::parse(open(query_url).read)
		return response_data 
	end 
	#################################################
	def is_lang_supported(lang)
		return @@langs_supported.has_key?(lang.downcase)
	end
	#################################################
	def get_lang_pair_str(lang1,lang2)
		return @@langs_supported[lang1.downcase] + "-" + @@langs_supported[lang2.downcase]
	end 
	#################################################
	def is_lang_pair_supported(lang1, lang2)
		# We only support a subset of all the langauges tha 
		# Yandex supports.
		if !is_lang_supported(lang1) || !is_lang_supported(lang2)
			return false 
		end

		pairs_supported = get_pairs_from_yandex()

		pair_str = get_lang_pair_str(lang1, lang2)

		#lp = LanguagePair.find_by :code => pair_str
		#return !lp.nil?
		return pairs_supported.include? pair_str
	end 
	#################################################
	def get_langs_supported
		return @@langs_supported.keys.map(&:capitalize)
	end
	##################################################
	def lookup(lang1, lang2, word)
		#if is_lang_pair_supported(lang1, lang2)
		# Create query url and then issue query to yandex
		base_url  = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key="
		url = base_url + @@api_key + "&lang=" + get_lang_pair_str(lang1,lang2) + "&text=" + word
		#url = base_url + @@api_key + "&lang=" + get_lang_pair_str(lang1,lang2)
		
		puts url 

		http_response = open(url)

		# If query was successful 
		if http_response.status[0] == "200"

			response_data = JSON::parse(http_response.read)

			# If the element keyed with "def" is empty, then that means the word 
			# we are trying to look up does not exist in the original language. 
			if response_data["def"].empty? 
				return {:has_error => true, :error_msg => "Could not translate " + word + " from " + lang1 + " to " + lang2, :error_code => 1}
			end 

			#No error, return response data 
			return {:has_error => false, :response_data => response_data}
			
		end

		# If you get here, then that means there was something wrong with our 
		# attempt at accessing the Yandex API. Should not happen if API key is 
		# correct. 
		return {:has_error => true, :error_msg => "Failed to access Yandex API.", :error_code => 2}

	end
end