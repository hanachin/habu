require "habu/version"
require "habu/container"
require "habu/annotation_collector"

module Habu
  class Error < StandardError; end

  class << self
    attr_accessor :annotation_collector
  end
end
