class Tag
  include ActiveModel::Model

  attr_accessor :name, :flashcards, :stack_path, :category
  validates_presence_of :name
  validates_presence_of :flashcards

  ############################################################################
  def self.user_defined_tags_to_tags(current_user)
  	user_defined_tags = UserDefinedTag.where(user_id: current_user.id)
  	tags = []
  	user_defined_tags.each do |udt| 
  		sp = "/stacks/by_tag/" + udt.id.to_s

  		tags << Tag.new(name: udt.name.capitalize, flashcards: udt.flashcards, stack_path: sp, category: 1)
  	end

  	return tags 
  end
  ############################################################################
  def self.batches_to_tags(current_user)
  	tags = []

    batches = Flashcard.joins(:batch).where(user_id: current_user.id).uniq.pluck(:batch_id)

    batches.each do |i|
      n = "batch " + i.to_s
      f = Flashcard.where(batch_id: i, user_id: current_user.id)
      sp = "stacks/by_batch/" + i.to_s 

      tags << Tag.new(name: n.capitalize, flashcards: f, stack_path: sp, category: 2)
    end

  	return tags
  end
  ############################################################################
  def self.lang_pairs_to_tags(current_user)
  	language_pairs = LanguagePair.all 
  	tags = []
  	language_pairs.each do |lp|
  		n = lp.from_lang.capitalize + " to " + lp.to_lang.capitalize
  		f = Flashcard.where(language_pair_id: lp.id, user_id: current_user.id)
  		sp = "stacks/by_langs/" + lp.code.sub('-','_')

  		tags << Tag.new(name: n, flashcards: f, stack_path: sp, category: 3)
  	end 

  	return tags 
  end
  ############################################################################
  def self.all(current_user) 
  	return (user_defined_tags_to_tags(current_user) + batches_to_tags(current_user) + lang_pairs_to_tags(current_user)).sort_by(&:name)
  end
  ############################################################################
  def self.get_tag_type(t) 
  	
  	if t == 1 then 
  		return "user defined tag"
  	elsif t == 2 then 
  		return "batch"
  	elsif t == 3 then 
  		return "language pair"
  	else 
  		return "invalid"
  	end

  end

  def self.tags_to_stacks(tags)
    stacks = []
    tags.each do |tag|
      s =  Stack.new(name: tag.name, category: tag.category)
      s.flashcards << tag.flashcards

      stacks << s 

    end 

    return stacks
  end
end