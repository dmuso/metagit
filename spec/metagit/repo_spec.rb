require 'spec_helper'
require 'fileutils'
require 'timecop'

module Metagit
  describe Repo do

    let(:repo_path) { "./tmp/test_repo_private" }
    let(:my_email) { "dan@dot.com" }

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

    describe "#name" do

      it "should not be the same as name" do
        expect(@repo.name).not_to eq "test_repo_private"
      end

    end

    describe "#readable?" do
      it 'the repo is readable' do
        expect(@repo.readable?).to eq true
      end
    end

    describe "#changes_since?" do
      it "should be true when there are changes" do
        expect(@repo.changes_since? @repo_raw.commits.first).to eq true
      end

      it "should be false when there are no changes" do
        expect(@repo.changes_since? @repo_raw.commits.last).to eq false
      end
    end
  end
end
