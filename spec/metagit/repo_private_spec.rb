require 'spec_helper'
require 'fileutils'
require 'timecop'

module Metagit
  describe RepoPrivate do

    let(:repo_path) { "./tmp/test_repo_private" }
    let(:my_email) { "dan@dot.com" }
    let(:not_my_email) { "notme@somewhere-else.com" }

    before :each do
      Timecop.freeze(Time.local(2014, 9, 1, 10, 0, 0))
      # we may mock this if speed/complexity get in the way
      @repo_raw = Metagit::Support::RuggedRepo.new(repo_path, my_email)
      @repo = RepoPrivate.new repo_path
      allow(Metagit).to receive(:config).and_return({
        "first_name"  => "Dan",
        "last_name"   => "Harper",
        "emails"      => [ my_email ]
      })
    end

    after :each do
      # clean up after ourselves
      FileUtils.rm_rf repo_path
      Timecop.return
    end


    describe "#stats_for_commit" do
      it "should have the email of the author" do
        expect(@repo.stats_for_commit(@repo_raw.commits.first)[:author_email]).to eq "dan@dot.com"
      end

      it "should have the commit timestamp" do
        # don't run this near midnight :) TODO: more accuracy
        expect(@repo.stats_for_commit(@repo_raw.commits.first)[:time]).to eq Time.now
      end

      it "should have the number of files changed" do
        expect(@repo.stats_for_commit(@repo_raw.commits.first)[:no_files_changed]).to eq 1
      end

      it "should have the number of insertions" do
        expect(@repo.stats_for_commit(@repo_raw.commits.first)[:no_insertions]).to eq 0
      end

      it "should have the number of deletions" do
        expect(@repo.stats_for_commit(@repo_raw.commits.first)[:no_deletions]).to eq 1
      end

      it "should also work for other commits" do
        expect(@repo.stats_for_commit(@repo_raw.commits[1])[:author_email]).not_to eq "dan@dot.com"
      end

      it "should also work for other commits files changed" do
        expect(@repo.stats_for_commit(@repo_raw.commits[1])[:no_files_changed]).to eq 1
      end
    end

    describe "#stats_overall" do
      it "should tell me how total commits there are" do
        expect(@repo.stats_overall[:no_total_commits]).to eq 3
      end

      it "should tell me how many commits are mine" do
        expect(@repo.stats_overall[:no_my_commits]).to eq 2
      end

      it "should tell when my last commit was" do
        expect(@repo.stats_overall[:last_contributed]).to eq Time.now
      end

      it "should tell me all the contributors" do
        expect(@repo.stats_overall[:contributors]).to eq [ my_email, not_my_email ]
      end

      it "should contain a list of my commits" do
        expect(@repo.stats_overall[:my_commits].size).to eq 2
      end

      it "should some detail on my commits" do
        expect(@repo.stats_overall[:my_commits].first[:no_files_changed]).to eq 1
      end
    end

    describe "#to_markdown" do
      it "should have the name as the heading" do
        expect(@repo.to_markdown).to match(/^# #{@repo.name.titleize}$/)
      end

      context "my contributions summary" do
        it "should have my contributions as a sub-heading" do
          expect(@repo.to_markdown).to match(/^## #{Metagit.config["first_name"]}'s Contribution Summary$/)
        end

        it "should have the total number of commits" do
          expect(@repo.to_markdown).to match(/^Total commits:( *)2$/)
        end

        it "should have my last contribution date" do
          expect(@repo.to_markdown).to match(/^Last contributed:( *)#{Time.now.year}/)
        end
      end

      context "repository summary" do
        it "should have the repository summary as a sub-heading" do
          expect(@repo.to_markdown).to match(/^## Repository Summary$/)
        end

        it "should have the total number of commits" do
          expect(@repo.to_markdown).to match(/^Total commits:( *)3$/)
        end

        it "should have the total number of contributors" do
          expect(@repo.to_markdown).to match(/^Contributors:( *)2$/)
        end
      end

      context "my commit history" do
        it "should have my commit history as a sub-heading" do
          expect(@repo.to_markdown).to match(/^## #{Metagit.config["first_name"]}'s Commits$/)
        end

        it "should have the timestamp of a commit" do
          expect(@repo.to_markdown).to match(/^#{@repo.stats_overall[:my_commits].first[:time].year}/)
        end

        it "should have the number of files changed" do
          expect(@repo.to_markdown).to match(/#{@repo.stats_overall[:my_commits].first[:no_files_changed]} files changed/)
        end

        it "should have the number of insertions" do
          expect(@repo.to_markdown).to match(/#{@repo.stats_overall[:my_commits].first[:no_insertions]} insertions/)
        end

        it "should have the number of deletions" do
          expect(@repo.to_markdown).to match(/#{@repo.stats_overall[:my_commits].first[:no_deletions]} deletions/)
        end

        it "should end with a line ending" do
          expect(@repo.to_markdown).to match(/deletions\n$/)
        end
      end
    end
  end
end
