require 'spec_helper'

describe 'constant_throughput_timer' do
  let(:doc) do
    test do
      threads do
        constant_throughput_timer value: 60.0
        constant_throughput_timer throughput: 70.0
      end
    end.to_doc
  end

  let(:fragment) { doc.search("//ConstantThroughputTimer").first }

  it 'should match on throughput using value' do
    expect(fragment.search("//doubleProp/value").first.text).to eq '60.0'
  end

  it 'should match on throughput using throughput' do
    expect(fragment.search("//doubleProp/value").last.text).to eq '70.0'
  end
end
