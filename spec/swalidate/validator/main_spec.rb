require 'spec_helper'

RSpec.describe Swalidate::Validator::Main do
  let(:detail) do
    {
      'description' => 'example endpoint',
      'parameters'  => [
        {
          'name'     => 'limit',
          'in'       => 'query',
          'required' => true,
          'type'     => 'integer'
        }
      ]
    }
  end
  let(:request_params) do
    {
      'limit' => 2
    }
  end

  let(:endpoint)  { Swalidate::Endpoint.new(detail) }
  let(:validator) { Swalidate::Validator::Main.new(endpoint, request_params) }

  context '#initialize' do
    it 'assign instance variables' do
      expect(validator.endpoint_params).to eq(detail['parameters'])
      expect(validator.request_params).to eq(request_params)
    end
  end

  context '#call' do
    it 'validates each parameter' do
      validator.call
    end
  end
end
