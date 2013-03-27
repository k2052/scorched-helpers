require_relative './helper.rb'

describe 'AssetsHelpers' do
  context 'for #stylesheet_link_tag method' do
    it 'should display stylesheet link item using' do
      time             = stop_time_for_test
      expected_options = {:media => "screen", :rel => "stylesheet", :type => "text/css"}
      app.css('style').should have_selector('link', expected_options.merge(:href => "/stylesheets/style.css?#{time.to_i}"))
    end

    it 'should display stylesheet link item for long relative path' do
      time             = stop_time_for_test
      expected_options = {:media => "screen", :rel => "stylesheet", :type => "text/css"}
      actual_html      = app.css('example/demo/style')
      actual_html.should have_selector('link', expected_options.merge(:href => "/stylesheets/example/demo/style.css?#{time.to_i}"))
    end

    it 'should display stylesheet link item with absolute path' do
      time             = stop_time_for_test
      expected_options = {:media => "screen", :rel => "stylesheet", :type => "text/css"}
      actual_html      = app.css('/css/style')
      actual_html.should have_selector('link', expected_options.merge(:href => "/css/style.css"))
    end

    it 'should display stylesheet link item with uri root' do
      app.class.stub(:uri_root).and_return("/blog")
      time             = stop_time_for_test
      expected_options = {:media => "screen", :rel => "stylesheet", :type => "text/css"}
      actual_html      = app.css('style')
      actual_html.should have_selector('link', expected_options.merge(:href => "/blog/stylesheets/style.css?#{time.to_i}"))
    end

    it 'should display stylesheet link items' do
      time        = stop_time_for_test
      actual_html = app.css('style', 'layout.css', 'http://google.com/style.css')
      actual_html.should have_selector('link', :media => "screen", :rel => "stylesheet", :type => "text/css", :count => 3) 
      actual_html.should have_selector('link', :href => "/stylesheets/style.css?#{time.to_i}") 
      actual_html.should have_selector('link', :href => "/stylesheets/layout.css?#{time.to_i}") 
      actual_html.should have_selector('link', :href => "http://google.com/style.css") 
      actual_html.should eq app.css(['style', 'layout.css', 'http://google.com/style.css'])
    end

    it 'should not use a timestamp if stamp setting is false' do
      app.class.stub(:asset_stamp).and_return(false)
      expected_options = { :media => "screen", :rel => "stylesheet", :type => "text/css" }
      app.css('style').should have_selector('link', expected_options.merge(:href => "/stylesheets/style.css"))
    end
  end

  context 'for #javascript_include_tag method' do
    it 'should display javascript item' do
      time        = stop_time_for_test
      actual_html = app.js('application')
      actual_html.should have_selector('script', :src => "/javascripts/application.js?#{time.to_i}", :type => "text/javascript")
    end

    it 'should display javascript item for long relative path' do
      time        = stop_time_for_test
      actual_html = app.js('example/demo/application')
      actual_html.should have_selector('script', :src => "/javascripts/example/demo/application.js?#{time.to_i}", :type => "text/javascript")
    end

    it 'should display javascript item for path containing js' do
      time        = stop_time_for_test
      actual_html = app.js 'test/jquery.json'
      actual_html.should have_selector('script', :src => "/javascripts/test/jquery.json?#{time.to_i}", :type => "text/javascript")
    end

    it 'should display javascript item for path containing period' do
      time        = stop_time_for_test
      actual_html = app.js 'test/jquery.min'
      actual_html.should have_selector('script', :src => "/javascripts/test/jquery.min.js?#{time.to_i}", :type => "text/javascript")
    end

    it 'should display javascript item with absolute path' do
      time        = stop_time_for_test
      actual_html = app.js('/js/application')
      actual_html.should have_selector('script', :src => "/js/application.js", :type => "text/javascript")
    end

    it 'should display javascript item with uri root' do
      app.class.stub(:uri_root).and_return("/blog")
      time        = stop_time_for_test
      actual_html = app.js('application')
      actual_html.should have_selector('script', :src => "/blog/javascripts/application.js?#{time.to_i}", :type => "text/javascript")
    end

    it 'should display javascript items' do
      time        = stop_time_for_test
      actual_html = app.js('application', 'base.js', 'http://google.com/lib.js')
      actual_html.should have_selector('script', :type => "text/javascript", :count => 3) 
      actual_html.should have_selector('script', :src => "/javascripts/application.js?#{time.to_i}") 
      actual_html.should have_selector('script', :src => "/javascripts/base.js?#{time.to_i}") 
      actual_html.should have_selector('script', :src => "http://google.com/lib.js") 
      actual_html.should eq app.js(['application', 'base.js', 'http://google.com/lib.js'])
    end

    it 'should not use a timestamp if stamp setting is false' do
      app.class.stub(:asset_stamp).and_return(false)
      actual_html = app.js('application')
      actual_html.should have_selector('script', :src => "/javascripts/application.js", :type => "text/javascript")
    end
  end
end
