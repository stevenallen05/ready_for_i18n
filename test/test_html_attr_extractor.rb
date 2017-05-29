require 'helper'

describe 'TestHtmlAttrExtractor' do
  # it "should extract the Some Attribute that need i18n from the HTML file" do
  #   f = File.join(File.dirname(__FILE__),'fixtures','html_attr.html.erb')
  #   expected = %w{Print Measure Save copy save2} << 'Compare on chart'
  #   result = []
  #   ReadyForI18N::HtmlAttrExtractor.new.extract(File.read(f)){|k,v| result << v}
  #   assert_same_elements(expected,result)
  # end
  
  it "should replace the attribut in html with t method" do
    source = File.join(File.dirname(__FILE__),'fixtures','html_attr.html.erb')
    output = ReadyForI18N::HtmlAttrExtractor.new.extract(File.read(source))
    %w{print measure save copy save2}.each do |e|
      expected = "<%=t('label_#{e}')%>"
      assert(output.include?(expected), "should found \"#{expected}\" t method with symbol")
    end
  end
  
end
