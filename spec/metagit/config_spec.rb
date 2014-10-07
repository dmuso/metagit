require 'spec_helper'

module Metagit
  describe "#config" do

    it 'read the config file' do
      expect(Metagit.config.has_key?('emails')).to eq true
    end

  end

end