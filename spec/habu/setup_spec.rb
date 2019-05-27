require 'spec_helper'
require 'habu/setup'

RSpec.describe Habu::Setup do
  describe '.install' do
    around do |example|
      original = Habu.annotation_collector
      example.run
      Habu.annotation_collector = original
    end

    it 'install annotation_collector' do
      aggregate_failures do
        annotation_collector = spy('annotation_collector')

        expect {
          Habu::Setup.install(annotation_collector)
        }.to change {
          Habu.annotation_collector
        }

        expect(annotation_collector).to have_received(:install)
      end
    end
  end
end
