require 'spec_helper'

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
end
