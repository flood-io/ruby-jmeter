require 'spec_helper'

describe 'xhr' do
  let(:doc) do
    test do
      threads do
        transaction name: "TC_02", parent: true, include_timers: true do
          visit url: "/" do
            with_xhr
          end
        end
      end
    end.to_doc
  end

  let(:fragment) { doc.search('//HeaderManager').first }

  it 'should match on XHR' do
    expect(fragment.search(".//stringProp[@name='Header.value']").text).to eq 'XMLHttpRequest'
  end
end

describe 'gzip' do
  let(:doc) do
    test do
      threads do
        transaction name: 'TC_02', parent: true, include_timers: true do
          visit url: '/' do
            with_gzip
          end
        end
      end
    end.to_doc
  end

  let(:fragment) { doc.search('//HeaderManager').first }

  it 'should match on Acept Encoding' do
    expect(fragment.search(".//stringProp[@name='Header.value']").text).to eq 'gzip, deflate'
  end
end

describe 'user agent' do
  let(:doc) do
    test do
      with_user_agent :chrome
      threads
    end.to_doc
  end

  let(:fragment) { doc.search('//HeaderManager').first }

  it 'should match on user_agent' do
    expect(fragment.search(".//stringProp[@name='Header.name']").text).to eq 'User-Agent'
    expect(fragment.search(".//stringProp[@name='Header.value']").text).to eq 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.46 Safari/536.5'
  end
end
