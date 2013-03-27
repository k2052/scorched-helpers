$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'webrat'
require 'scorched'
require 'slim'
require 'scorched-helpers'

# We set our target application and rack test environment using let. This ensures tests are isolated, and allows us to
# easily swap out our target application.
module GlobalConfig
  extend RSpec::SharedContext
  include Webrat::Methods
  include Webrat::Matchers

  Webrat.configure do |config|
    config.mode = :rack
  end

  def stop_time_for_test
    time = Time.now
    Time.stub(:now).and_return(time)
    return time
  end

  let(:app) do
    class App < Scorched::Controller
      register ScorchedHelpers

      def root
        return File.expand_path('/public', __FILE__)
      end

      def captures
        request.captures
      end

      def captured_content(&block)
        content_html = capture_html(&block)
        "<p>#{content_html}</p>"
      end

      def concat_in_p(content_html)
        concat_content "<p>#{content_html}</p>"
      end

      def determine_block_is_template(name, &block)
        concat_content "<p class='is_template'>The #{name} block passed in is a template</p>" if block_is_template?(block)
      end

      def ruby_not_template_block
        determine_block_is_template('ruby') do
          content_tag(:span, "This not a template block")
        end
      end

      get '/:engine/:file' do 
        render captures[:file].to_sym, engine: captures[:engine].to_sym
      end
    end    

    return App.new({})
  end
  
  let(:rt) do
    Rack::Test::Session.new(app)
  end
  
  original_dir = __dir__
  before(:all) do
    Dir.chdir(__dir__)
  end
  after(:all) do
    Dir.chdir(original_dir)
  end
end

RSpec.configure do |c|
  c.alias_example_to :they
  c.include GlobalConfig
end
