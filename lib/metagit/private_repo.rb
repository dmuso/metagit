require 'git'

module Metagit
  class PrivateRepo

    def initialize(working_dir)
      @working_dir = working_dir

      @g = Git.open(@working_dir)
    end

    def readable?
      @g.index.readable?
    end

    def log
      @g.log
    end

  end
end