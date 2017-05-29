require 'helper'

describe 'TestErbHelperExtractor' do
  it "should extract the label that need i18n from the erb view file" do
    f = File.join(File.dirname(__FILE__),'fixtures','index.html.erb')
    result = []
    ReadyForI18N::ErbHelperExtractor.new.extract(File.read(f)){|k,v| result << v}
    expected = %w{edit delete select export cancel} << "Add Event"
    # assert_same_elements(expected,result)
  end
  
  it "should replace the label in helper with t method" do
    source = File.join(File.dirname(__FILE__),'fixtures','index.html.erb')
    target = File.join(File.dirname(__FILE__),'output','label.html.erb')
    output = nil
    File.open(source){|f| output = ReadyForI18N::ErbHelperExtractor.new.extract(f)}
    File.open(target,'w+'){|f| f << output}
    expected = %w{edit delete select export cancel add_event}
    expected.each do |e|
      assert(File.read(target).include?("t('label_#{e}')"), "should found t method with symbol")
      assert(!File.read(target).include?("<%=t('label_#{e}')%>"), "should Not found t method wrapped.")
    end
  end
  
end
