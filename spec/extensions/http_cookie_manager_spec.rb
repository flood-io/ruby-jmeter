require 'spec_helper'

describe 'http_cookie_manager' do
  describe 'the clear_each_iteration option should be respected' do
    let(:doc) do
      test do
        cookies clear_each_iteration: true
      end.to_doc
    end

    let(:cookies_fragment) { doc.search("//CookieManager") }

    it 'should match on clearEachIteration' do
      expect(cookies_fragment.search(".//boolProp[@name='CookieManager.clearEachIteration']").first.text).to eq'true'
    end
  end
end
