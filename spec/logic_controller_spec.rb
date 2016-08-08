require 'spec_helper'

describe 'disabled elements' do
  let(:doc) do
    test do
      header name: 'Accept', value: '*', enabled: false
    end.to_doc
  end

  let(:fragment) {  doc.search('//HeaderManager') }

  it 'should be disabled' do
    expect(fragment.first.attributes['enabled'].value).to eq 'false'
  end
end

describe 'If' do
  let(:doc) do
    test do
      threads do
        If condition: '2>1' do
          visit url: "/"
        end
      end
    end.to_doc
  end

  let(:fragment) { doc.search("//IfController").first }

  it 'should match on If' do
    expect(fragment.search(".//stringProp[@name='IfController.condition']").text).to eq '2>1'
  end
end

describe 'exists' do
  let(:doc) do
    test do
      threads do
        exists 'apple' do
          visit url: "/"
        end
      end
    end.to_doc
  end

  let(:fragment) { doc.search("//IfController").first }

  it 'should match on exists' do
    expect(fragment.search(".//stringProp[@name='IfController.condition']").text).to eq '"${apple}" != "\${apple}"'
  end
end

describe 'While' do
  let(:doc) do
    test do
      threads do
        While condition: 'true' do
          visit url: "/"
        end
      end
    end.to_doc
  end

  let(:fragment) { doc.search('//WhileController').first }

  it 'should match on While' do
    expect(fragment.search(".//stringProp[@name='WhileController.condition']").text).to eq 'true'
  end
end

describe 'Counter' do
  let(:doc) do
    test do
      threads do
        visit url: "/" do
          counter start: 1, per_user: true
        end
      end
    end.to_doc
  end

  let(:fragment) { doc.search('//CounterConfig').first }

  it 'should match on 5 Loops' do
    expect(fragment.search(".//boolProp[@name='CounterConfig.per_user']").text).to eq 'true'
  end
end

describe 'Switch' do
  let(:doc) do
    test do
      threads do
        Switch value: 'cat' do
          visit url: "/"
        end
      end
    end.to_doc
  end

  let(:fragment) { doc.search('//SwitchController').first }

  it 'should match on Switch' do
    expect(fragment.search(".//stringProp[@name='SwitchController.value']").text).to eq 'cat'
  end
end

describe 'Nested controllers' do
  let(:doc) do
    test do
      Simple name: 'node1.1' do
        Simple name: 'node2.1'
        Simple name: 'node2.2' do
          Simple name: 'node3.1'
        end
        Simple name: 'node2.3'
      end
      Simple name: 'node1.2'
    end.to_doc
  end

  let(:node1_1) { doc.search("//GenericController[@testname='node1.1']").first }
  let(:node1_2) { doc.search("//GenericController[@testname='node1.2']").first }

  let(:node2_1) { doc.search("//GenericController[@testname='node2.1']").first }
  let(:node2_2) { doc.search("//GenericController[@testname='node2.2']").first }
  let(:node2_3) { doc.search("//GenericController[@testname='node2.3']").first }

  let(:node3_1) { doc.search("//GenericController[@testname='node3.1']").first }

  it 'nodes should have hashTree as its parent' do
    [node1_1, node1_2, node2_1, node2_2, node2_3, node3_1].each do |node|
      expect(node.parent.name).to eq 'hashTree'
    end
  end

  describe 'node3_1' do
    it 'parent parent should be node2_2' do
      expect(node3_1.parent).to eq node2_2.next
    end
  end

  describe 'node1_2' do
    it 'previous non hashTree sibling is node1_1' do
      expect(node1_2.previous.previous).to eq node1_1
    end
  end
end

