module Census
  class Configuration
    attr_accessor :admin_role

    def initialize
      @admin_role = true
    end
  end

  class << self
    attr_accessor :configuration
  end

  # Configure Census someplace sensible,
  # like config/initializers/census.rb
  #
  # @example
  #   Census.configure do |config|
  #     config.admin_role = 'current_user.admin?'
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
