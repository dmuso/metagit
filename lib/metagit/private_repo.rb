require 'rugged'
require 'namazing'
require 'active_support/inflections'

module Metagit
  class PrivateRepo

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
      stats_overall = {
        no_my_commits: 0,
        no_total_commits: 0,
        last_contributed: Time.at(0),
        contributors: [],
        my_commits: []
      }
      walker = Rugged::Walker.new(@repo)
      walker.sorting(Rugged::SORT_DATE)
      walker.push(@repo.head.target)
      walker.each do |c|
        stats_overall[:no_total_commits] += 1
        if !stats_overall[:contributors].include?(c.to_hash[:author][:email])
          stats_overall[:contributors] << c.to_hash[:author][:email]
        end
        if Metagit.config["emails"].include?(c.to_hash[:author][:email])
          stats_overall[:no_my_commits] += 1
          stats_overall[:last_contributed] = c.to_hash[:author][:time]
          stats_overall[:my_commits] << stats_for_commit(c.oid)
        end
      end
      walker.reset
      stats_overall
    end

    def to_markdown
      md = <<-eof
# #{self.name.titleize}

## #{Metagit.config["first_name"]}'s Contribution Summary

Total commits:      #{self.stats_overall[:no_my_commits]}
Last contributed:   #{self.stats_overall[:last_contributed]}

## Repository Summary

Total commits:      #{self.stats_overall[:no_total_commits]}
Contributors:       #{self.stats_overall[:contributors].length}

## #{Metagit.config["first_name"]}'s Commits

eof
      self.stats_overall[:my_commits].each do |commit|
        md += "#{commit[:time]}   #{commit[:no_files_changed]} files changed, #{commit[:no_insertions]} insertions, #{commit[:no_deletions]} deletions"
      end
      md
    end

  end
end