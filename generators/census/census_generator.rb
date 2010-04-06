require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")
require File.expand_path(File.dirname(__FILE__) + "/lib/rake_commands.rb")

class CensusGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory File.join("config", "initializers")
      m.file "census.rb",  "config/initializers/census.rb"
      
      m.directory File.join("public", "javascripts")
      m.file "census.js", "public/javascripts/census.js"
      
      user_model = "app/models/user.rb"
      if File.exists?(user_model)
        m.insert_into user_model, "include Census::User"
      else
        m.directory File.join("app", "models")
        m.file "user.rb", user_model
      end

      m.directory File.join("test", "factories")
      m.file "factories.rb", "test/factories/census.rb"

      if ActiveRecord::Base.connection.table_exists?(:users)
        m.migration_template "migrations/without_users.rb",
                             'db/migrate',
                             :migration_file_name => "create_census_tables"
      else
        m.migration_template "migrations/with_users.rb",
                             'db/migrate',
                             :migration_file_name => "create_census_tables"
      end
      
      m.readme "README"
    end
  end

end
