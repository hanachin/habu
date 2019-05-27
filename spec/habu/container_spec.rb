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
end
