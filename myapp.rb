    # myapp.rb
    require 'sinatra'
    require 'open-uri'
    require 'rdiscount'
    require_relative 'Formatter'

    set :views, settings.root
  
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
        logger.info "REQUEST_PATH: #{request.env['REQUEST_PATH']}"                
        path = add_parameters(request.env['REQUEST_PATH'], params)
        logger.info "Path: #{path}"

        Format = Formatter.new(path)
        rules = Hash.new
        rules [/([0-9][0-9])\/([0-9][0-9])\/([0-9][0-9][0-9][0-9])/] = "\\3-\\2-\\1"
        rules [/(N\/E)/] = "0.0"        

        if Format.targer_url == nil
            return "There's a problem with the URL format"            
        end

        target = Format.get_body(Format.targer_url)
        
        if target.body == nil
            return "Remote server returned: '#{target.result}'"
        end

        target.body = Format.format_body(rules, target.body)
        type = "#{target.content_type}; charset = UTF-8"
        halt 200, {'Content-Type' => type, 'Content-length' => target.size.to_s}, target.body
    end

    def add_parameters(path, params)        
        len = params.length-1 # -1 because sinatra seems to add an extra parameter "splat"
        logger.info "Params length-1: #{len}"
        if len > 0
            path << "?"
            params.take(len).each_with_index { |(key, value) , index|
                path << "#{key}=#{value}"
                path << "&" if index + 1 < len
            }
        end
        path
    end
