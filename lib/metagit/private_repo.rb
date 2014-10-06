require 'rugged'

module Metagit
  class PrivateRepo

    def initialize(working_dir)
      @working_dir = working_dir

      @g = Rugged::Repository.new(@working_dir)
    end

    def readable?
      !@g.index.nil?
    end

    def log
      @g.log
    end

  end
end