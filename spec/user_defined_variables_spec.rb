require 'spec_helper'

describe 'user_defined_variables' do
  let(:doc) do
    test do
      variables [
        { name: 'email', value: 'support@flood.io' },
        { name: 'password', value: 'correcthorsebatterystaple' }
      ]
    end.to_doc
  end

  let(:fragment) { doc.search('//Arguments').first }
  let(:collectionProp) { fragment.search("//collectionProp[@name='Arguments.arguments']").first }

  it 'should have collection properties' do
    expect(collectionProp.search("//stringProp[@name='Argument.name']").first.text).to eq 'email'
    expect(collectionProp.search("//stringProp[@name='Argument.value']").first.text).to eq 'support@flood.io'
    expect(collectionProp.search("//stringProp[@name='Argument.name']").last.text).to eq 'password'
    expect(collectionProp.search("//stringProp[@name='Argument.value']").last.text).to eq 'correcthorsebatterystaple'
  end
end
