require 'spec_helper'

RSpec.describe Habu::Container do
  describe '#[]' do
    it 'store and load object' do
      container = Habu::Container.new
      container[:api_key] { 'my_api_key' }
      expect(container[:api_key]).to eq('my_api_key')
    end
  end
end
