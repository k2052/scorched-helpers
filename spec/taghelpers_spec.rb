require_relative './helper.rb'

describe 'TagHelpers' do
  context 'for #tag method' do
    it 'should support tags with no content no attributes' do
      app.tag(:br).should have_selector(:br)
    end

    it 'should support tags with no content with attributes' do
      actual_html = app.tag(:br, :style => 'clear:both', :class => 'yellow')
      actual_html.should have_selector(:br, :class => 'yellow', :style=>'clear:both')
    end

    it "should support selected attribute by using 'selected' if true" do
      actual_html = app.tag(:option, :selected => true)
      actual_html.should have_selector('option', :selected => 'selected')
    end

    it 'should support data attributes' do
      actual_html = app.tag(:a, :data => { :remote => true, :method => 'post'})
      actual_html.should have_selector(:a, 'data-remote' => 'true', 'data-method' => 'post')
    end

    it 'support nested attributes' do
      actual_html = app.tag(:div, :data => {:dojo => {:type => 'dijit.form.TextBox', :props => 'readOnly: true'}})
      actual_html.should have_selector(:div, 'data-dojo-type' => 'dijit.form.TextBox', 'data-dojo-props' => 'readOnly: true')
    end

    it 'should support open tags' do
      actual_html = app.tag(:p, { :class => 'demo' }, true)
      "<p class=\"demo\">".should eq actual_html
    end

    it 'should escape html' do
      actual_html = app.tag(:br, :class => 'Example "bar"')
      "<br class=\"Example &quot;bar&quot;\" />".should eq actual_html
    end
  end

  context 'for #content_tag method' do
    it 'should support tags with content as parameter' do
      actual_html = app.content_tag(:p, "Demo", :class => 'large', :id => 'thing')
      actual_html.should have_selector('p.large#thing', :content => "Demo")
    end

    it 'should support tags with content as block' do
      actual_html = app.content_tag(:p, :class => 'large', :id => 'star') { "Demo" }
      actual_html.should have_selector('p.large#star', :content => "Demo") 
    end

    it 'should support tags with slim' do
      response = rt.get '/slim/content_tag'
      response.should have_selector :p, :content => 'Test 1', :class => 'test', :id => 'test1'
      response.should have_selector :p, :content => 'Test 2'
      response.should have_selector :p, :content => 'Test 3', :class => 'test', :id => 'test3'
      response.should have_selector :p, :content => 'Test 4'
    end
  end

  context 'for #input_tag method' do
    it 'should support field with type' do
      app.input_tag(:text).should have_selector('input[type=text]')
    end

    it 'should support field with type and options' do
      actual_html = app.input_tag(:text, :class => "first", :id => 'texter')
      actual_html.should have_selector('input.first#texter[type=text]')
    end

    it "should support checked attribute by using 'checked' if true" do
      actual_html = app.input_tag(:checkbox, :checked => true)
      actual_html.should have_selector('input[type=checkbox]', :checked => 'checked')
    end

    it "should support disabled attribute by using 'disabled' if true" do
      actual_html = app.input_tag(:checkbox, :disabled => true)
      actual_html.should have_selector('input[type=checkbox]', :disabled => 'disabled')
    end
  end
end
