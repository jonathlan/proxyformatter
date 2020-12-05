require 'rspec'
require_relative '../Formatter.rb'

describe Formatter do
    target = "https://sampleapis.com/countries/api/countries"
    faiulre_target = ""
    before {
        path = "/formatr/https://sampleapis.com/countries/api/countries"        
        @formatter = Formatter.new(path)
    }

    #Specifications
    # targer_url
    it "Should extract the target url from path" do
        expect(@formatter.targer_url).to eq target
    end

    it "Should return nil if the path format is not correct" do
        wrong_path = "http://localhost/formatr/https://sampleapis.com/countries/api/countries"
        expect(@formatter.targer_url(wrong_path)).to be_nil
    end

    # get_body
    it "Returns successful response" do
        server = @formatter.get_body(target)
        expect(server.body).not_to eq nil
        expect(server.size).to be > 0
        expect(server.result).to eq "OK"
    end

    it "Returns error response" do
        server = @formatter.get_body(faiulre_target)
        expect(server.body).to eq nil
        expect(server.size).to eq 0
        expect(server.result).not_to eq "OK"
    end

    # format_body
    it "Formats body content according to one expression" do
        rules = Hash.new
        rules [/([0-9][0-9])\/([0-9][0-9])\/([0-9][0-9][0-9][0-9])/] = "\\3-\\2-\\1"
        rules [/(N\/E)/] = "0.0"
        body = "<fecha>11/01/2008</fecha>"
        newbody = @formatter.format_body(rules, body)
        expect(newbody).to eq "<fecha>2008-01-11</fecha>"
    end

    it "Formats body content according to more than one expression" do
        rules = Hash.new
        rules [/([0-9][0-9])\/([0-9][0-9])\/([0-9][0-9][0-9][0-9])/] = "\\3-\\2-\\1"
        rules [/(N\/E)/] = "0.0"
        body = "<dato>N/E</dato><fecha>08/12/2014</fecha>"
        newbody = @formatter.format_body(rules, body)
        expect(newbody).to eq "<dato>0.0</dato><fecha>2014-12-08</fecha>"
    end

    it "Returns empty body if received empty parameters" do
        empty_rules = Hash.new
        body = ""
        expect(@formatter.format_body(empty_rules, body)).to eq ""
    end

end