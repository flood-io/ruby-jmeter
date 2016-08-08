require 'spec_helper'

describe 'setup thread groups' do
  let(:doc) do
    test do
      setup_thread_group count: 101, continue_forever: true, duration: 69
    end.to_doc
  end

  let(:fragment) { doc.search("//SetupThreadGroup").first }

  it 'should match on num_threads' do
    expect(fragment.search(".//stringProp[@name='ThreadGroup.num_threads']").text).to eq '101'
  end

  it 'should match on scheduler' do
    expect(fragment.search(".//boolProp[@name='ThreadGroup.scheduler']").text).to eq 'true'
  end

  it 'should match on continue_forever' do
    expect(fragment.search(".//boolProp[@name='LoopController.continue_forever']").text).to eq 'true'
  end

  it 'should match on loops' do
    expect(fragment.search(".//stringProp[@name='LoopController.loops']").text).to eq '-1'
  end

  it 'should match on duration' do
    expect(fragment.search(".//stringProp[@name='ThreadGroup.duration']").text).to eq '69'
  end
end
