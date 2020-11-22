    # myapp.rb
    require 'sinatra'
    require 'open-uri'
    # https://mensfeld.pl/2013/01/ruby-on-rails-webrick-error-nomethoderror-undefined-method-split-for-nilnilclass/
    
#class Myapp < Sinatra::Base
    
    get '/' do
        "Welcome!"
    end

    get '/format' do    
        # matches "GET /format?url=foo&token=bar"
        ORS = "\r\n"
        content_type = ''
        targeturl = params['url']
        params.each { |key, value|         
            targeturl << "&#{key}=#{value}" if key != 'url'
        }
        
        body = URI.open(targeturl) {|f|
        content_type = f.content_type
        f.read
        }
        # Change date format from DD/MM/YYYY to YYYY-MM-DD
        body.gsub!(/([0-9][0-9])\/([0-9][0-9])\/([0-9][0-9][0-9][0-9])/, "\\3-\\2-\\1")
        # Some web servers send N/E in the response, remove it as we don't need it for our tests.
        body.gsub!(/(N\/E)/, "0.0")
        body << ORS
        type = "#{content_type}; charset = UTF-8"
        halt 200, {'Content-Type' => type, 'Content-length' => body.length}, body
    end

    #get %r{/formatr/(https?://(www.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/=]*))} do
    get '/formatr/*' do
        request.url
    end
#end