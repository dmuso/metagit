require 'rugged'
require 'namazing'
require 'active_support/inflections'

module Metagit
  class Repo

    def initialize(repo_path)
      @repo_path = repo_path
      @repo = Rugged::Repository.new(@repo_path)
    end

    def name
      Namazing.to_awesome @repo.workdir.split("/").last
    end

    def readable?
      !@repo.index.nil?
    end

    def changes_since? sha
      @repo.lookup(sha) != @repo.head.target
    end

  end
end