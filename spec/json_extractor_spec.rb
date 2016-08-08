require 'spec_helper'

describe 'json extract' do
  let(:doc) do
    test do
      extract json: '.test.path', name: 'my_json'
    end.to_doc
  end

  let(:fragment) { doc.search("//com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.JSONPathExtractor").first }

  it 'should match on json path' do
    expect(fragment.search(".//stringProp[@name='JSONPATH']").text).to eq '.test.path'
  end

  it 'should match on json var' do
    expect(fragment.search(".//stringProp[@name='VAR']").text).to eq 'my_json'
  end
end
