# frozen_string_literal: true

require 'spec_helper'

describe 'http_cookie_manager' do
  describe 'the clear_each_iteration option should be respected' do
    let(:doc) do
      test do
        cookies clear_each_iteration: true
      end.to_doc
    end

    let(:cookies_fragment) { doc.search('//CookieManager') }

    it 'should match on clearEachIteration' do
      expect(cookies_fragment.search(".//boolProp[@name='CookieManager.clearEachIteration']").first.text).to eq 'true'
    end
  end

  describe 'the user_defined_cookie option should be respected' do
    context 'when the user_defined_cookie option is empty' do
      let(:doc) do
        test do
          cookies
        end.to_doc
      end

      let(:cookies_fragment) { doc.search('//CookieManager') }

      it 'should not populate the collectionProp' do
        expect(cookies_fragment.search("..//collectionProp[@name='CookieManager.cookies']").children.count).to eq 0
      end
    end

    context 'when the user_defined_cookie option is set' do
      let(:cookie_name) { 'cookie_1' }
      let(:cookie_value) { 'cookie_value' }
      let(:cookie_domain) { 'example.com' }
      let(:cookie_path) { '/' }
      let(:cookie_secure) { true }

      let(:cookies_fragment) { doc.search('//CookieManager') }
      let(:elements) { cookies_fragment.search("..//collectionProp[@name='CookieManager.cookies']").children }

      context 'with all the cookie attributes provided' do
        let(:doc) do
          test do
            cookies user_defined_cookies: [
              {
                name: cookie_name,
                value: cookie_value,
                domain: cookie_domain,
                path: cookie_path,
                secure: cookie_secure
              }
            ]
          end.to_doc
        end

        it 'should add an element to the cookie manager collection' do
          expect(elements.count).to eq 1
        end

        it 'should add the correct name to the collection element' do
          expect(elements.first.attribute('name').value).to eq cookie_name
        end

        it 'should add the correct elementType to the collection element' do
          expect(elements.first.attribute('elementType').value).to eq 'Cookie'
        end

        it 'should add the correct testName to the collection element' do
          expect(elements.first.attribute('testname').value).to eq cookie_name
        end

        it 'should add a Cookie.value stringProp to the element' do
          expect(elements.first.search("//stringProp[@name='Cookie.value']").text).to eq cookie_value
        end

        it 'should add a Cookie.domain stringProp to the element' do
          expect(elements.first.search("//stringProp[@name='Cookie.domain']").text).to eq cookie_domain
        end

        it 'should add a Cookie.path stringProp to the element' do
          expect(elements.first.search("//stringProp[@name='Cookie.path']").text).to eq cookie_path
        end

        it 'should add a Cookie.secure boolProp to the element' do
          expect(elements.first.search("//boolProp[@name='Cookie.secure']").text).to eq 'true'
        end

        it 'should add a Cookie.expires longProp to the element' do
          expect(elements.first.search("//longProp[@name='Cookie.expires']").text).to eq '0'
        end

        it 'should add a Cookie.path_specified boolProp to the element' do
          expect(elements.first.search("//boolProp[@name='Cookie.path_specified']").text).to eq 'true'
        end

        it 'should add a Cookie.domain_specified boolProp to the element' do
          expect(elements.first.search("//boolProp[@name='Cookie.domain_specified']").text).to eq 'true'
        end
      end

      context 'without optional cookie attributes provided' do
        let(:doc) do
          test do
            cookies user_defined_cookies: [
              {
                name: cookie_name,
                value: cookie_value
              }
            ]
          end.to_doc
        end

        it 'should add a default Cookie.secure boolProp to the element' do
          expect(elements.first.search("//boolProp[@name='Cookie.secure']").text).to eq 'false'
        end

        it 'should add a default Cookie.domain stringProp to the element' do
          expect(elements.first.search("//stringProp[@name='Cookie.domain']").text).to eq ''
        end

        it 'should add a default Cookie.path stringProp to the element' do
          expect(elements.first.search("//stringProp[@name='Cookie.path']").text).to eq ''
        end
      end

      context 'without required cookie attributes provided' do
        it 'should raise an error if name is not provided' do
          expect { test { cookies user_defined_cookies: [{ value: cookie_value }] } }
            .to raise_error('Cookie name must be provided.')
        end
        it 'should raise an error if value is not provided' do
          expect { test { cookies user_defined_cookies: [{ name: cookie_name }] } }
            .to raise_error('Cookie value must be provided.')
        end
      end

      context 'when multiple cookies are set' do
        let(:doc) do
          test do
            cookies user_defined_cookies: [
              {
                name: cookie_name,
                value: cookie_value,
                domain: cookie_domain,
                path: cookie_path,
                secure: cookie_secure
              },
              {
                name: cookie_name,
                value: cookie_value,
                domain: cookie_domain,
                path: cookie_path,
                secure: cookie_secure
              }
            ]
          end.to_doc
        end

        it 'should add multiple elements to the cookie manager collection' do
          expect(elements.count).to eq 2
        end
      end
    end
  end
end
