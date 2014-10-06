require 'rugged'

module Metagit
  class PrivateRepo

    def initialize(repo_path)
      @repo_path = repo_path
      @repo = Rugged::Repository.new(@repo_path)
    end

    def readable?
      !@repo.index.nil?
    end

    def changes_since? sha
      @repo.lookup(sha) != @repo.head.target
    end

  end
end