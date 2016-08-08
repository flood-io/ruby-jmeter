require 'spec_helper'

describe 'xpath extract' do
  let(:doc) do
    test do
      extract xpath: '//node', name: 'my_xpath'
    end.to_doc
  end

  let(:fragment) { doc.search('//XPathExtractor').first }

  it 'should match on refname' do
    expect(fragment.search(".//stringProp[@name='XPathExtractor.refname']").text).to eq 'my_xpath'
  end
end
