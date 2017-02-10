require 'spec_helper'

RSpec.describe Swalidate::Validator::Parameter do
  let(:param_required) { true }
  let(:param) do
    {
      'name'     => 'limit',
      'in'       => 'query',
      'required' => param_required,
      'type'     => 'integer'
    }
  end
  let(:value) { 2 }

  let(:parameter) { Swalidate::Validator::Parameter.new(param, value) }

  context '#initialize' do
    it 'assign instance variables' do
      expect(parameter.param).to eq(param)
      expect(parameter.value).to eq(value)
    end
  end

  context '#valid?' do
    context 'value is not exists' do
      let(:value) { nil }

      context 'param is required' do
        before do
          expect(parameter).to receive(:required?).and_return(true)
        end

        it 'returns false' do
          expect(parameter.valid?).to eq(false)
        end
      end

      # context 'param is not required' do
      #   before do
      #     expect(parameter).to receive(:required?).and_return(true)
      #   end

      #   it 'returns false' do
      #     expect(parameter.valid?).to eq(false)
      #   end
      # end
    end
  end

  context '#required?' do
    context 'required => true' do
      it 'returns true' do
        expect(parameter.required?).to eq(true)
      end
    end

    context 'required => false' do
      let(:param_required) { false }

      it 'returns false' do
        expect(parameter.required?).to eq(false)
      end
    end
  end

  context '#exists?' do
    context 'value is 2' do
      it 'returns true' do
        expect(parameter.exists?).to eq(true)
      end
    end

    context 'value is nil' do
      let(:value) { nil }

      it 'returns false' do
        expect(parameter.exists?).to eq(false)
      end
    end
  end
end
