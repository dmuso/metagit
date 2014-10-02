require 'spec_helper'

module Metagit
  describe  'CONFIG' do
    it 'read the config file' do
      #require 'pry'; binding.pry;
      expect(CONFIG.has_key?('emails')).to eq true
    end
  end

end