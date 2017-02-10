require 'spec_helper'

RSpec.describe Swalidate::Schema do
  let(:file_path) { 'spec/fixtures/yaml/petstore-simple.yaml' }
  let(:schema)    { Swalidate::Schema.new(file_path) }

  context '#initialize' do
    it 'parses file' do
      expect(schema.paths).to be_kind_of(Hash)
      expect(schema.definitions).to be_kind_of(Hash)
    end
  end

  # context 'should_validate?' do
  #   context 'valid method and path' do
  #     let(:method) { 'GET' }
  #     let(:path)   { '/pets' }

  #     it 'return true' do
  #       expect(schema.should_validate?(method, path)).to eq(true)
  #     end
  #   end

  #   context 'invalid method' do
  #     let(:method) { 'DELETE' }
  #     let(:path)   { '/pets' }

  #     it 'return true' do
  #       expect(schema.should_validate?(method, path)).to eq(false)
  #     end
  #   end

  #   context 'invalid path' do
  #     let(:method) { 'POST' }
  #     let(:path)   { '/petsxx' }

  #     it 'return true' do
  #       expect(schema.should_validate?(method, path)).to eq(false)
  #     end
  #   end
  # end
end
