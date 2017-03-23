class FillLanguagePairsTableJob < ActiveJob::Base
  queue_as :high_priority

  def perform(*args)
    # query yandex
    yandex = YandexDictClient.new
    langs_supported = yandex.get_langs_supported_as_hash()
    pairs_from_yandex = yandex.get_pairs_from_yandex()

    langs_supported.each do |full_lang1, lang_code1|
    	langs_supported.each do |full_lang2, lang_code2|
    		unless full_lang1 == full_lang2
    			pair_str = lang_code1 + "-" + lang_code2
    			if pairs_from_yandex.include? pair_str 
    				lp = LanguagePair.new({:from_lang => full_lang1, :to_lang => full_lang2, :code => pair_str})
    				if lp.valid?
    					lp.save
    				end 
    			end
    		end 
    	end 
    end 
    
  end
end
