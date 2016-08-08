require 'spec_helper'

describe 'assertions' do
  describe 'json assertion' do
    let(:doc) do
      test do
        visit '/' do
          assert json: '.key', value: 'value'
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.JSONPathAssertion').first }

    it 'should match on expected value' do
      expect(fragment.search(".//stringProp[@name='EXPECTED_VALUE']").text).to eq "value"
    end

    it 'should match on json path' do
      expect(fragment.search(".//stringProp[@name='JSON_PATH']").text).to eq ".key"
    end

    it 'should have json validation by default' do
      expect(fragment.search(".//boolProp[@name='JSONVALIDATION']").text).to eq "true"
    end
  end
end

