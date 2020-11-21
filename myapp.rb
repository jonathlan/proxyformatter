    # myapp.rb
    require 'sinatra'
    require 'open-uri'

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
