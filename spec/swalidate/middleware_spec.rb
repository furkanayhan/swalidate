require 'spec_helper'

RSpec.describe Swalidate::Middleware do
  let(:file_path)   { 'spec/fixtures/yaml/petstore-simple.yaml' }
  let(:subdomain)   { 'api' }
  let(:path_prefix) { '/v1' }


  let(:options) do
    {
      file_path:   file_path,
      subdomain:   subdomain,
      path_prefix: path_prefix
    }
  end

  let(:env)        { {} }
  let(:app)        { double(call: true) }
  let(:middleware) { Swalidate::Middleware.new(app, options) }

  let(:request) do
    double(
      subdomain: 'api',
      path:      '/v1/pets/2',
      method:    'GET',
      params:    {}
    )
  end

  before do
    allow(ActionDispatch::Request).to receive(:new).and_return(request)
  end

  context '#initialize' do
    it 'assigns instance variables' do
      expect(middleware.instance_variable_get(:@schema)).to be_kind_of(Swalidate::Schema)
      expect(middleware.instance_variable_get(:@subdomain)).to eq('api')
      expect(middleware.instance_variable_get(:@path_prefix)).to eq('/v1')
    end
  end

  context 'should_validate?' do
    shared_examples_for 'valid: should_validate?' do
      it 'calls Swalidate::Validator::Main.new(args).call' do
        expect_any_instance_of(Swalidate::Validator::Main).to receive(:call)
        middleware.call(env)
      end
    end

    shared_examples_for 'invalid: should_validate?' do
      it 'calls Swalidate::Validator::Main.new(args).call' do
        expect_any_instance_of(Swalidate::Validator::Main).not_to receive(:call)
        middleware.call(env)
      end
    end

    context 'valid_subdomain?' do
      before do
        allow(middleware).to receive(:valid_path_prefix?).and_return(true)
        allow(middleware).to receive(:valid_path?).and_return(true)
      end

      context 'valid' do
        it_behaves_like 'valid: should_validate?'
      end

      context 'invalid' do
        let(:subdomain) { 'xavi' }

        it_behaves_like 'invalid: should_validate?'
      end
    end

    context 'valid_path_prefix?' do
      before do
        allow(middleware).to receive(:valid_subdomain?).and_return(true)
        allow(middleware).to receive(:valid_path?).and_return(true)
      end

      context 'valid' do
        it_behaves_like 'valid: should_validate?'
      end

      context 'invalid' do
        let(:path_prefix) { '/v2' }

        it_behaves_like 'invalid: should_validate?'
      end
    end

    context 'valid_path?' do
      before do
        allow(middleware).to receive(:valid_subdomain?).and_return(true)
        allow(middleware).to receive(:valid_path_prefix?).and_return(true)
      end

      context 'valid' do
        before do
          expect_any_instance_of(Swalidate::Endpoint).to receive(:should_validate?).and_return(true)
        end

        it_behaves_like 'valid: should_validate?'
      end

      context 'invalid' do
        let(:path_prefix) { '/v2' }

        before do
          expect_any_instance_of(Swalidate::Endpoint).to receive(:should_validate?).and_return(false)
        end

        it_behaves_like 'invalid: should_validate?'
      end
    end
  end
end
