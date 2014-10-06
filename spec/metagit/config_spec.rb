require 'spec_helper'

module Metagit
  describe CONFIG do

    it 'read the config file' do
      expect(subject.has_key?('emails')).to eq true
    end

  end

end