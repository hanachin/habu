require "habu/version"
require "habu/annotation_collector"
require "habu/container"
require "habu/factory"

module Habu
  class Error < StandardError; end

  class << self
    attr_accessor :annotation_collector
  end
end
