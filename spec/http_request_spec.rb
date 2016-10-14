require 'spec_helper'

describe 'http_request' do
  describe 'get basic' do
    let(:doc) do
      test do
        threads count: 1 do
          get name: 'Home Page', url: 'https://flooded.io/'
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'matches on method' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq 'GET'
    end

    it 'matches on domain' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.domain']").text).to eq 'flooded.io'
    end

    it 'matches on port' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.port']").text).to eq '443'
    end

    it 'matches on protocol' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.protocol']").text).to eq 'https'
    end

    it 'matches on path' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.path']").text).to eq '/'
    end
  end

  describe 'get with options' do
    let(:doc) do
      test do
        threads count: 1 do
          get name: 'Home Page', url: 'https://flooded.io/', follow_redirects: false, use_keepalive: false
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'matches on domain' do
      expect(fragment.search(".//boolProp[@name='HTTPSampler.follow_redirects']").text).to eq 'false'
    end

    it 'matches on port' do
      expect(fragment.search(".//boolProp[@name='HTTPSampler.use_keepalive']").text).to eq 'false'
    end
  end

  describe 'visit' do
    let(:doc) do
      test do
        threads count: 1 do
          visit name: 'Home Page', url: 'https://flooded.io/'
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'matches on method' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq 'GET'
    end
  end

  describe 'visit variations' do
    let(:doc) do
      test do
        threads do
          visit url: "/home?location=melbourne&location=sydney", always_encode: true
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on path' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.path']").text).to eq '/home'
    end

    context 'first argument' do
      it 'should match on always_encode' do
        expect(fragment.search(".//boolProp[@name='HTTPArgument.always_encode']")[0].text).to eq 'true'
      end

      it 'should match on query param name: location' do
        expect(fragment.search(".//stringProp[@name='Argument.name']")[0].text).to eq 'location'
      end

      it 'should match on query param value: melbourne' do
        expect(fragment.search(".//stringProp[@name='Argument.value']")[0].text).to eq 'melbourne'
      end
    end

    context 'second argument' do
      it 'should match on always_encode' do
        expect(fragment.search(".//boolProp[@name='HTTPArgument.always_encode']")[1].text).to eq 'true'
      end

      it 'should match on query param name: location' do
        expect(fragment.search(".//stringProp[@name='Argument.name']")[1].text).to eq 'location'
      end

      it 'should match on query param value: sydney' do
        expect(fragment.search(".//stringProp[@name='Argument.value']")[1].text).to eq 'sydney'
      end
    end
  end

  describe 'visit old syntax' do
    let(:doc) do
      test do
        threads do
          visit "/home?location=melbourne", always_encode: true
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on path' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.path']").text).to eq '/home'
    end
  end

  describe 'https' do
    let(:doc) do
      test do
        threads do
          visit url: "https://example.com"
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on protocol' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.protocol']").text).to eq 'https'
    end
  end

  describe 'post' do
    let(:doc) do
      test do
        threads count: 1 do
          post name: 'Home Page', url: 'https://flooded.io/'
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'matches on method' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq 'POST'
    end
  end

  describe 'post raw_path' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_02" do
            post url: "/home?location=melbourne", raw_path: true
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on path' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.path']").text).to eq '/home?location=melbourne'
    end
  end

  describe 'post raw body containing xml entities' do
    let(:doc) do
      test do
        threads do
          post url: 'http://example.com', raw_body: 'username=my_name&password=my_password&email="my name <test@example.com>"'
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'escape raw_body' do
      expect(fragment.search(".//stringProp[@name='Argument.value']").text).to eq 'username=my_name&password=my_password&email="my name <test@example.com>"'
    end
  end

  describe 'submit' do
    let(:doc) do
      test do
        threads count: 1 do
          submit name: 'Home Page', url: 'https://flooded.io/'
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'matches on method' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq 'POST'
    end
  end

  describe 'submit variations' do
    let(:doc) do
      test do
        threads do
          submit url: '/', fill_in: { username: 'tim', password: 'password' }
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'should match on POST' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq 'POST'
    end

    it 'should have no files' do
      expect(fragment.search(".//elementProp[@name='HTTPsampler.Files']").length).to eq 0
    end
  end

  describe 'submit_with_files' do
    let(:doc) do
      test do
        threads do
          transaction name: "TC_03", parent: true, include_timers: true do
            submit url: "/", fill_in: { username: 'tim', password: 'password' },
                   files: [{path: '/tmp/foo', paramname: 'fileup', mimetype: 'text/plain'},
                           {path: '/tmp/bar', paramname: 'otherfileup'}]
          end
        end
      end.to_doc
    end

    let(:fragment) { doc.search("//HTTPSamplerProxy/elementProp[@name='HTTPsampler.Files']").first }

    it 'should have two files' do
      expect(fragment.search("./collectionProp/elementProp[@elementType='HTTPFileArg']").length).to eq 2
    end

    it 'should have one empty mimetype' do
      expect(fragment.search("./collectionProp/elementProp[@elementType='HTTPFileArg']/stringProp[@name='File.mimetype' and normalize-space(.) = '']").length).to eq 1
    end
  end

  describe 'patch' do
    let(:doc) do
      test do
        threads count: 1 do
          patch name: 'Home Page', url: 'https://flooded.io/'
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'matches on method' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq 'PATCH'
    end
  end

  describe 'head' do
    let(:doc) do
      test do
        threads count: 1 do
          head name: 'Home Page', url: 'https://flooded.io/'
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'matches on method' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq 'HEAD'
    end
  end

  describe 'put' do
    let(:doc) do
      test do
        threads count: 1 do
          put name: 'Home Page', url: 'https://flooded.io/'
        end
      end.to_doc
    end

    let(:fragment) { doc.search('//HTTPSamplerProxy').first }

    it 'matches on method' do
      expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq 'PUT'
    end
  end
end
