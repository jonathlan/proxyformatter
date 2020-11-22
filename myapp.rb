    # myapp.rb
    require 'sinatra'
    require 'open-uri'
   
    get '/' do
        "Welcome!"
    end

    get '/format/*' do
        # Target address should be received after the /format/
        ORS = "\r\n"
        content_type = ''
        requrl = request.url
        
        # Get the base URL
        base = requrl.slice(/(https?:\/\/[-a-zA-Z0-9@:%._\+~#=]{1,256}\/format\/)/)
        rsize = requrl.size
        # Get the actual target URL that's embeded in request.url, that's after /format/
        targeturl = requrl.slice(base.size,rsize)
        # Patch to put missing slash in 'http:/' this means that only secure addresses are supported
        targeturl.gsub!(/https?:\/w/,"https://w")
        # Now open the retrieve target contents
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


    get '/formatr/*' do
        requrl = request.url
        
        # Get the base URL
        base = requrl.slice(/(https?:\/\/[-a-zA-Z0-9@:%._\+~#=]{1,256}\/formatr\/)/)
        rsize = requrl.size
        # Get the actual target URL that's embeded in request.url, that's after /format/
        targeturl = requrl.slice(base.size,rsize)
        # Patch to put missing slash in 'http:/' this means that only secure addresses are supported
        targeturl.gsub!(/https?:\/w/,"https://w")
    end
