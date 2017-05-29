require 'helper'
require 'stringio'

describe 'TestKeyMapper' do
  it "should Find the key of the specified text according to mapper string" do
    text_en = "key one\nkey two\n"
    text_cn = "jian yi\njian er\n"
    
    mapper = ReadyForI18N::KeyMapper.new(text_en,text_cn)
    assert_equal("key_one", mapper.key_for("jian yi"))
    assert_equal("jian_yi", mapper.key_for("key one"))
  end
  
  it "should Raise an Error when two file are in different line numbers" do
    text_en = "key one\nkey two\n"
    text_cn = "jian yi\njian er"
    assert_nothing_raised(Exception) { mapper = ReadyForI18N::KeyMapper.new(text_en,text_cn) }

    text_en = "key one\nkey two\n"
    text_cn = "jian yi\n"
    assert_raises(RuntimeError) { mapper = ReadyForI18N::KeyMapper.new(text_en,text_cn) }
  end
end
