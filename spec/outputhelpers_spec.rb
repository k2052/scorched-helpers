require_relative './helper.rb'

describe 'OutputHelpers' do
  context 'for #content_for method' do
    it 'should work for slim templates' do
      response = rt.get('/slim/content_for')
      response.should have_selector '.demo h1',  :content => "This is content yielded from a content_for"
      response.should have_selector '.demo2 h1', :content => "This is content yielded with name Johnny Smith"
    end
  end

  context 'for #content_for? method' do
     it 'should work for slim templates' do
      response = rt.get('/slim/content_for')
      response.should have_selector '.demo_has_content', :content => 'true'
      response.should have_selector '.fake_has_content', :content => 'false'
    end
  end

  context 'for #capture_html method' do
    it 'should work for slim templates' do
      response = rt.get '/slim/capture_concat'
      response.should have_selector 'p span', :content => "Captured Line 1"
      response.should have_selector 'p span', :content => "Captured Line 2"
    end
  end

  context 'for #concat_content method' do
    it 'should work for slim templates' do
      response = rt.get '/slim/capture_concat'
      response.should have_selector 'p', :content => "Concat Line 3", :count => 1
    end
  end

  context 'for #block_is_template?' do
    # TODO get this passing
    # it 'should work for slim templates' do
    #   response = rt.get '/slim/capture_concat'
    #   response.should have_selector 'p', :content => "The slim block passed in is a template", :class => 'is_template'
    #   response.should have_selector 'p', :content => "The ruby block passed in is a template", :class => 'is_template'
    # end
  end

  context 'for #current_engine method' do
    it 'should detect correctly current engine for slim' do
      app.render_defaults[:engine] = :slim
      response = rt.get '/slim/current_engine'
      response.should have_selector 'p.slim', :content => 'slim'
      response.should have_selector 'p.end',  :content => 'slim'
    end
  end

  context 'for #partial method in simple sinatra application' do
    it 'should properly output in slim' do
      response = rt.get  '/slim/simple_partial'
      response.should have_selector 'p.slim',  :content => 'slim'
    end
  end
end
