require 'spec_helper'

describe 'transaction controller' do
  let(:doc) do
    test do
      threads do
        transaction name: 'TC_01', parent: false, include_timers: true
        transaction name: 'TC_02', parent: true, include_timers: false
      end
    end.to_doc
  end

  let(:fragment) { doc.search("//TransactionController") }

  it 'should match on parent when false' do
    expect(fragment.first.search(".//boolProp[@name='TransactionController.parent']").text).to eq 'false'
  end

  it 'should match on includeTimers when true' do
    expect(fragment.first.search(".//boolProp[@name='TransactionController.includeTimers']").text).to eq 'true'
  end

  it 'should match on parent when true' do
    expect(fragment.last.search(".//boolProp[@name='TransactionController.parent']").text).to eq 'true'
  end

  it 'should match on includeTimers when false' do
    expect(fragment.last.search(".//boolProp[@name='TransactionController.includeTimers']").text).to eq 'false'
  end
end
