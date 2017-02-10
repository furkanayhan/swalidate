require 'spec_helper'

RSpec.describe Swalidate::Types::Main do
  let(:param_type)      { 'integer' }
  let(:param_format)    { 'int32' }
  let(:param_minimum)   { nil }
  let(:param_maximum)   { nil }
  let(:param_minLength) { nil }
  let(:param_maxLength) { nil }

  let(:param) do
    {
      'name'      => 'limit',
      'in'        => 'query',
      'required'  => true,
      'type'      => param_type,
      'format'    => param_format,
      'minimum'   => param_minimum,
      'maximum'   => param_maximum,
      'minLength' => param_minLength,
      'maxLength' => param_maxLength
    }
  end

  let(:value) { 2 }
  let(:type)  { Swalidate::Types::Main.new(param, value) }

  context '#initialize' do
    it 'assign instance variables' do
      expect(type.casted_value).to eq(2)
      expect(type.errors).to eq([])
    end
  end

  context '#valid? and casted_value' do
    context 'value is nil' do
      let(:value) { nil }

      it 'returns NilObject.new' do
        expect(type.casted_value).to eq('NilObject.new')
      end
    end

    context 'value is integer' do
      context 'param-type is integer' do
        it 'returns 2 and valid' do
          expect(type.casted_value).to eq(2)
          expect(type.valid?).to eq(true)
        end
      end

      context 'param-type is number' do
        let(:param_type) { 'number' }

        it 'returns 2 and valid' do
          expect(type.casted_value).to eq(2)
          expect(type.valid?).to eq(true)
        end
      end

      context 'param-type is numeric' do
        context 'minimum is set' do
          let(:param_minimum) { 3 }

          it 'returns 2 and invalid' do
            expect(type.casted_value).to eq(2)
            expect(type.valid?).to eq(false)
          end
        end

        context 'maximum is set' do
          let(:param_maximum) { 1 }

          it 'returns 2 and invalid' do
            expect(type.casted_value).to eq(2)
            expect(type.valid?).to eq(false)
          end
        end
      end

      context 'param-type is string' do
        let(:param_type) { 'string' }
        let(:value)      { 'example' }

        context 'param-format is default' do
          let(:param_format) { '' }

          it "returns 'example' and valid" do
            expect(type.casted_value).to eq('example')
            expect(type.valid?).to eq(true)
          end

          context 'minLength is set' do
            let(:param_minLength) { 10 }

            it "returns 'example' and invalid" do
              expect(type.casted_value).to eq('example')
              expect(type.valid?).to eq(false)
            end
          end

          context 'maxLength is set' do
            let(:param_maxLength) { 3 }

            it "returns 'example' and invalid" do
              expect(type.casted_value).to eq('example')
              expect(type.valid?).to eq(false)
            end
          end
        end

        context 'param-format is date' do
          let(:param_format) { 'date' }

          it 'returns nil and invalid' do
            expect(type.casted_value).to eq(nil)
            expect(type.valid?).to eq(false)
          end
        end

        context 'param-format is date-time' do
          let(:param_format) { 'date-time' }

          it 'returns nil and invalid' do
            expect(type.casted_value).to eq(nil)
            expect(type.valid?).to eq(false)
          end
        end
      end
    end

    context 'param-type is boolean' do
      let(:param_type) { 'boolean' }

      it 'returns nil' do
        expect(type.casted_value).to eq(nil)
        expect(type.valid?).to eq(false)
      end
    end
  end
end
