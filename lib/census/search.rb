module Census
  class Search
    def initialize(options)
      @options = options
    end
    
    def perform
      results = nil
      @options.each_pair do |question, value|
        users = question.find_answers_matching(value).map(&:user)
        results = results ? results & users : users
      end
      results || []
    end
  end
end
