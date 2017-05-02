require 'spec_helper'

describe 'http_cache_manager' do
  describe 'the clear_each_iteration option should be respected' do
    let(:doc) do
      test do
        cache clear_each_iteration: true
      end.to_doc
    end

    let(:cache_fragment) { doc.search("//CacheManager") }

    it 'should match on clearEachIteration' do
      expect(cache_fragment.search(".//boolProp[@name='clearEachIteration']").first.text).to eq 'true'
    end
  end

  describe 'the use_expires option should be respected' do
    let(:doc) do
      test do
        cache use_expires: true
      end.to_doc
    end
     let(:cache_fragment) { doc.search("//CacheManager") }
     it 'should match on useExpires' do
      expect(cache_fragment.search(".//boolProp[@name='useExpires']").first.text).to eq 'true'
    end
  end
end
