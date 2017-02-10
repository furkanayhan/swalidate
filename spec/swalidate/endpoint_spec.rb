require 'spec_helper'

RSpec.describe Swalidate::Endpoint do
  let(:detail) do
    {
      'description' => 'example endpoint',
      'parameters'  => [
        {
          'name'     => 'limit',
          'in'       => 'query',
          'required' => false,
          'type'     => 'integer'
        }
      ]
    }
  end
  let(:endpoint) { Swalidate::Endpoint.new(detail) }

  context '#initialize' do
    it 'assigns parameters' do
      expect(endpoint.parameters).to eq(detail['parameters'])
    end
  end

  context 'should_validate?' do
    context 'valid detail' do
      it 'returns true' do
        expect(endpoint.should_validate?).to eq(true)
      end
    end

    context 'invalid detail' do
      let(:detail) { nil }

      it 'returns false' do
        expect(endpoint.should_validate?).to eq(false)
      end
    end
  end
end
