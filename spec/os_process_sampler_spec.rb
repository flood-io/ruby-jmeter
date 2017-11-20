require 'spec_helper'

describe 'os_process_sampler' do
  let(:sampler_fragment) { doc.search('//SystemSampler').first }
  let(:arguments_fragment) { sampler_fragment.search(".//elementProp[@name='SystemSampler.arguments']") }
  let(:collection_fragment) { arguments_fragment.search(".//collectionProp['Argument.arguments']") }

  context 'when no command args are provided' do
    let(:doc) do
      test do
        threads count: 1 do
          os_process_sampler command: 'my_command'
        end
      end.to_doc
    end

    it 'there are no arguments' do
      expect(arguments_fragment.text).to eq ''
    end
  end

  context 'command args are provided' do
    let(:doc) do
      test do
        threads count: 1 do
          os_process_sampler command: 'my_command', command_args: ['arg1', 'arg2']
        end
      end.to_doc
    end

    let(:elemprop_fragments) { collection_fragment.search(".//elementProp[@elementType='Argument']") }

    it 'the arguments are passed through' do
      expect(elemprop_fragments.count).to eq 2
    end

    it 'contains an entry for each argument' do
      expect(elemprop_fragments.first.search(".//stringProp[@name='Argument.value']").first.text).to eq('arg1')
      expect(elemprop_fragments.last.search(".//stringProp[@name='Argument.value']").first.text).to eq('arg2')
    end
  end
end
