require 'spec_helper'
require 'habu/setup'

RSpec.describe Habu::Container do
  describe '#[]' do
    it 'store and load object' do
      container = described_class.new
      container[:api_key] { 'my_api_key' }
      expect(container[:api_key]).to eq('my_api_key')
    end

    it 'yield self to the block' do
      container = described_class.new
      container[:api_key] { 'secret' }
      container[:api_client] { Struct.new(:api_key) }
      container[:default_api_client] { |c| c[:api_client].new(c[:api_key]) }
      expect(container[:default_api_client].api_key).to eq('secret')
    end
  end

  describe '#factories'do
    great_service = 'great service'
    container = described_class.new
    container[:great_service] { great_service }

    it 'define service as factory method' do
      expect(container.factories.great_service).to eq('great service')
    end

    describe '#to_refinements' do
      using container.factories.to_refinements

      it 'refines Object to access service' do
        expect(self.great_service).to eq('great service')
      end
    end
  end

  describe '#new' do
    class ApiClient
      attr_reader :api_key, :host

      def initialize(api_key, host)
        @api_key = api_key
        @host = host
      end
    end

    it 'bind objects to passed method' do
      container = described_class.new
      container[:api_key] { 'secret' }
      container[:host] { 'example.com' }
      api_client = container.new(ApiClient)
      expect(api_client.api_key).to eq('secret')
      expect(api_client.host).to eq('example.com')
    end
  end

  load 'app/user_repository.rb'
  load 'app/user_service.rb'

  describe '#to_refinements' do
    container = described_class.new
    using container.to_refinements

    it 'raise error if dependent object is not found' do
      expect { UserService.new }.to raise_error(KeyError, /key not found: :user_repository/)
    end
  end

  describe '#to_refinements' do
    container = described_class.new
    container[:user_repository] { UserRepository }
    using container.to_refinements

    it 'refines .new by constructor injection' do
      expect { UserService.new }.not_to raise_error
    end
  end
end
