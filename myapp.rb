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
        
        body = open(targeturl) {|f|
        content_type = f.content_type
        f.read
        }    
        body.gsub!(/([0-9][0-9])\/([0-9][0-9])\/([0-9][0-9][0-9][0-9])/, "\\3-\\2-\\1")
        body << ORS
        type = "#{content_type}; charset = UTF-8"
        halt 200, {'Content-Type' => type, 'Content-length' => body.length}, body
    end
