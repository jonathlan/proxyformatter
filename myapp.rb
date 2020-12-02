    # myapp.rb
    require 'sinatra'
    require 'open-uri'
    require 'rdiscount'
    require_relative 'Formatter'

    set :views, settings.root

    configure do
        enable :logging
    end
   
    get '/' do
        markdown :README
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
        targeturl.gsub!(/https?:\//,"https://")
        # Now open the retrieve target contents
        body = ''
        URI.open(targeturl) {|f|
            content_type = f.content_type
            body = f.read
        }
        # Change date format from DD/MM/YYYY to YYYY-MM-DD
        body.gsub!(/([0-9][0-9])\/([0-9][0-9])\/([0-9][0-9][0-9][0-9])/, "\\3-\\2-\\1")
        # Some web servers send N/E in the response, remove it as we don't need it for our tests.
        body.gsub!(/(N\/E)/, "0.0")
        body << ORS
        type = "#{content_type}; charset = UTF-8"
        halt 200, {'Content-Type' => type, 'Content-length' => body.length.to_s}, body
    end


    get '/formatr/*' do
        puts "Heroku Path: #{request.env['REQUEST_URI']}"
        logger.info "Logger Heroku Path: #{request.env['REQUEST_URI']}"
        Format = Formatter.new(request.env['REQUEST_URI'])
        rules = Hash.new
        rules [/([0-9][0-9])\/([0-9][0-9])\/([0-9][0-9][0-9][0-9])/] = "\\3-\\2-\\1"
        rules [/(N\/E)/] = "0.0"        

        if Format.targer_url == nil
            return "There's a problem with the URL format"            
        end
        #debug"
        if true
            return "URL?: #{Format.targer_url}"
        end
        #Debug            
        target = Format.get_body(Format.targer_url)
        
        if target.body == nil
            return "Remote server returned: '#{target.result}'"
        end

        target.body = Format.format_body(rules, target.body)
        type = "#{target.content_type}; charset = UTF-8"
        halt 200, {'Content-Type' => type, 'Content-length' => target.size.to_s}, target.body
    end
