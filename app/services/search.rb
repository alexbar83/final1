class Search
  OBJECTS_SEARCH = %w(All Questions Answers Comments Users)

  def self.search_results(search_text, search_object)
    if search_object == 'All' || search_object.empty?
      return ThinkingSphinx.search search_text
    end
    search_object.singularize.constantize.search search_text
  end
end 
