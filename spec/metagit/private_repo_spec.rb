require 'spec_helper'

module Metagit
  describe PrivateRepo do

    let(:repo_path) { "./tmp/test_repo_private" }
    let(:my_email) { "dan@dot.com" }

    before :each do
      # we may mock this if speed/complexity get in the way
      @repo_raw = Metagit::Support::RuggedRepo.new(repo_path, my_email)
      @repo = PrivateRepo.new repo_path
    end

    after :each do
      # clean up after ourselves
      require 'fileutils'
      FileUtils.rm_rf repo_path
    end


    it 'the repo is readable' do
      expect(@repo.readable?).to eq true
    end

    describe "#changes_since?" do

      it "should be true when there are changes" do
        expect(@repo.changes_since? @repo_raw.commits.first).to eq true
      end

      it "should be true when there are no changes" do
        expect(@repo.changes_since? @repo_raw.commits.last).to eq false
      end

    end


  end
end