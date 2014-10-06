require 'spec_helper'

module Metagit
  describe  PrivateRepo do

    repo = PrivateRepo.new CONFIG["groups"].first["private_repos"].first["path"]

    it 'the repo is readable' do
      expect(repo.readable?).to eq true
    end

    describe "#changes_since?" do

      subject { PrivateRepo.changes_since? "d84ee003b0495c7426c4e13814579e2bb2a3830d" }

      it "should" do
        skip
      end

    end

  end
end