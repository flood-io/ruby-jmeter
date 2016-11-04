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

  describe 'the user_cookies option allows for user defined cookies to be used' do
    let(:doc) do
      test do
        cookies user_cookies: { origin: { value: "jmeter", domain: 'domain' } }
      end.to_doc
    end

    let(:cookies_fragment) { doc.search("//CookieManager") }

    it 'has a "cookie jar" in the document' do
      expect(cookies_fragment.search(".//collectionProp[@name='CookieManager.cookies']").first).not_to be_nil
    end

    it 'should have created cookie in document' do
      expect(cookies_fragment.search(".//collectionProp[@name='CookieManager.cookies']").first.search(".//elementProp[@name='origin']")).not_to be_nil
    end
  end
end
