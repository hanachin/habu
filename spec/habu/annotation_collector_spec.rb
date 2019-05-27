require 'spec_helper'
require 'habu/setup'

RSpec.describe Habu::AnnotationCollector do
  it 'collect constructor anotations' do
    annotation_collector = Habu.annotation_collector
    annotation_collector.constructor_annotations.clear
    expect {
      load 'app/user_repository.rb'
      load 'app/user_service.rb'
    }.to change {
      annotation_collector.constructor_annotations
    }.from([]).to([:UserService])
  end
end
