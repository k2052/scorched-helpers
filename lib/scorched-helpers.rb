require 'cgi'
require 'scorched-helpers/support_lite' unless defined?(SupportLite)
require 'i18n'
require 'enumerator'
require 'active_support/time_with_zone'               # next extension depends on this
require 'active_support/core_ext/string/conversions'  # to_date
require 'active_support/option_merger'                # with_options
require 'active_support/core_ext/object/with_options' # with_options
require 'active_support/inflector'                    # humanize
begin
  require 'active_support/core_ext/float/rounding'      # round
rescue LoadError # built into 1.9.3
  # do nothing  
end

FileSet.glob_require('scorched-helpers/helpers/**/*.rb', __FILE__)

# Load our locales
I18n.load_path += Dir["#{File.dirname(__FILE__)}/scorched-helpers/locale/*.yml"]

module ScorchedHelpers
  class << self
    ##
    # Registers helpers into your application:
    #
    def registered(app)
      app.helpers Scorched::Helpers::Output
      app.helpers Scorched::Helpers::Tags
      app.helpers Scorched::Helpers::Translation
      app.helpers Scorched::Helpers::Assets
    end
    alias :included :registered
  end
end
