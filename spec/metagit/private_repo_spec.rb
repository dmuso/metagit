require 'spec_helper'

module Metagit
  describe PrivateRepo do

    let(:repo_path) { "./tmp/test_repo_private" }
    let(:my_email) { "dan@dot.com" }

    before :each do
      # we may mock this if speed/complexity get in the way
      Metagit::Support::RuggedRepo.new(repo_path, my_email)
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

      subject { PrivateRepo.changes_since? "d84ee003b0495c7426c4e13814579e2bb2a3830d" }

      it "should" do
        skip
      end

    end


  end
end