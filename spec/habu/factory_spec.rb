require 'spec_helper'

RSpec.describe Habu::Factory do
  describe '#register' do
    it 'define service as method' do
      factory = described_class.new(Habu::Container.new)
      factory.register(:great_service) { 'great service' }
      expect(factory.great_service).to eq('great service')
    end
  end

  describe '#resolve' do
    it 'call factory block' do
      factory = described_class.new(Habu::Container.new)
      factory.register(:great_service) { 'great service' }
      expect(factory.resolve(:great_service)).to eq('great service')
    end
  end

  describe '#to_refinements' do
    factory = described_class.new(Habu::Container.new)
    factory.register(:great_service) { 'great service' }
    using factory.to_refinements

    it 'refines Object to access service' do
      expect(great_service).to eq('great service')
    end
  end
end
