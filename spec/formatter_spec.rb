require 'rspec'
require_relative '../Formatter.rb'

describe Formatter do
    target = "https://sampleapis.com/countries/api/countries"
    before {
        path = "/formatr/https://sampleapis.com/countries/api/countries"        
        @formatter = Formatter.new(path)
    }

    #Specifications
    it "Should extract the target url from path" do
        expect(@formatter.targer_url).to eq target
    end

    it "Should return nil if the path format is not correct" do
        wrong_path = "http://localhost/formatr/https://sampleapis.com/countries/api/countries"
        expect(@formatter.targer_url(wrong_path)).to be_nil
    end

    it "Should return target's body" do        
        server = @formatter.get_body(target)
        expect(server.result).to eq "OK"
    end
end