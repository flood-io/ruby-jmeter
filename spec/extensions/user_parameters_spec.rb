require 'spec_helper'

describe 'user_parameters' do
  let(:doc) do
    test do
      threads do
        transaction name: 'user_parameters', parent: true, include_timers: true do
          visit url: "/" do
            user_parameters names: ['name1', 'name2'],
              thread_values: {
                user_1: [
                  'value1',
                  'value2'
                ],

                user_2: [
                  'value1',
                  'value2'
                ]
              },
              per_iteration: true
          end
        end
      end
    end.to_doc
  end

  let(:fragment) { doc.search('//UserParameters').first }
  let(:names) { doc.search("//collectionProp[@name='UserParameters.names']").first }
  let(:thread_values) { doc.search("//collectionProp[@name='UserParameters.thread_values']").first }

  it 'should match on names' do
    expect(names.search(".//stringProp[@name='name1']").text).to eq 'name1'
    expect(names.search(".//stringProp[@name='name2']").text).to eq 'name2'
  end

  it 'should match on thread values' do
    expect(thread_values.search(".//stringProp[@name='0']").first.text).to eq 'value1'
    expect(thread_values.search(".//stringProp[@name='1']").first.text).to eq 'value2'
  end

  it 'should match on per iteration' do
    expect(fragment.search(".//boolProp[@name='UserParameters.per_iteration']").text).to eq 'true'
  end
end