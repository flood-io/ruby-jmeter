require 'spec_helper'

describe 'throughput controller' do
  let(:doc) do
    test do
      threads do
        throughput_controller percent: 99 do
          transaction name: "TC_01", parent: true, include_timers: true
        end
      end
    end.to_doc
  end

  let(:fragment) { doc.search("//ThroughputController").first }

  it 'should match on maxThroughput' do
    expect(fragment.search(".//intProp[@name='ThroughputController.maxThroughput']").text).to eq '99'
    expect(fragment.search(".//FloatProperty/value").text).to eq '99.0'
  end

  it 'should match on style' do
    expect(fragment.search(".//intProp[@name='ThroughputController.style']").text).to eq '1'
  end
end
