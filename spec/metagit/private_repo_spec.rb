require 'spec_helper'

module Metagit
  describe  Private_repo do

    repo = Private_repo.new CONFIG["groups"].first["private_repos"].first["path"]

    it 'the repo is readable' do
      expect(repo.readable?).to eq true
    end


  end
end