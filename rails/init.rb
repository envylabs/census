require 'acts_as_list'
require 'inverse_of'
require 'census'

config.to_prepare do
  ApplicationController.helper(CensusHelper)
end