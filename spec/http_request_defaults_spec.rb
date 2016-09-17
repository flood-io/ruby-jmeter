require 'spec_helper'

describe 'regular_expression_extractor' do
  describe 'standard scope' do
    let(:doc) do
      test do
        defaults domain: 'example.com',
            protocol: 'https',
            implementation: 'HttpClient3.1',
            download_resources: true,
            use_concurrent_pool: 5,
            urls_must_match: 'http.+?example.com',
            proxy_host: 'proxy',
            proxy_port: 8080
      end.to_doc
    end

    let(:config_fragment) { doc.search('//ConfigTestElement').first }
    let(:sampler_fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'matches on domain' do
      expect(config_fragment.search(".//stringProp[@name='HTTPSampler.domain']").text).to eq 'example.com'
    end

    it 'matches on protocol' do
      expect(config_fragment.search(".//stringProp[@name='HTTPSampler.protocol']").text).to eq 'https'
    end

    it 'matches on implementation' do
      expect(config_fragment.search(".//stringProp[@name='HTTPSampler.implementation']").text).to eq 'HttpClient3.1'
    end

    it 'matches on image_parser' do
      expect(config_fragment.search(".//boolProp[@name='HTTPSampler.image_parser']").text).to eq 'true'
    end

    it 'matches on concurrent download' do
      expect(config_fragment.search(".//boolProp[@name='HTTPSampler.concurrentDwn']").text).to eq 'true'
    end

    it 'matches on concurrent pool' do
      expect(config_fragment.search(".//stringProp[@name='HTTPSampler.concurrentPool']").text).to eq '5'
    end

    it 'matches on embedded url regex' do
      expect(config_fragment.search(".//stringProp[@name='HTTPSampler.embedded_url_re']").text).to eq 'http.+?example.com'
    end

    it 'matches on proxy_host' do
      expect(config_fragment.search(".//stringProp[@name='HTTPSampler.proxyHost']").text).to eq 'proxy'
    end

    it 'matches on proxy_port' do
      expect(config_fragment.search(".//stringProp[@name='HTTPSampler.proxyPort']").text).to eq '8080'
    end
  end
end
