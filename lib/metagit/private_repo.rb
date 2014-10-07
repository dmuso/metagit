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

    def stats_for_commit sha
      stats = {}
      commit = @repo.lookup(sha)
      commit_hash = @repo.lookup(sha).to_hash
      stats[:author_email] = commit_hash[:author][:email]
      stats[:time] = commit_hash[:author][:time]
      stats[:no_files_changed] = commit.diff.stat[0]
      stats[:no_insertions] = commit.diff.stat[1]
      stats[:no_deletions] = commit.diff.stat[2]
      stats
    end

    def stats_overall
      stats_overall = { no_my_commits: 0 }
      walker = Rugged::Walker.new(@repo)
      walker.sorting(Rugged::SORT_DATE)
      walker.push(@repo.head.target)
      walker.each do |c|
        if Metagit.config["emails"].include?(c.to_hash[:author][:email])
          stats_overall[:no_my_commits] += 1
        end
      end
      walker.reset
      stats_overall
    end

  end
end