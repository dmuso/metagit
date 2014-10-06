require 'spec_helper'

module Metagit
  describe  PrivateRepo do

    repo = PrivateRepo.new CONFIG["groups"].first["private_repos"].first["path"]

    it 'the repo is readable' do
      expect(repo.readable?).to eq true
    end


  end
end