class Formatter
    attr_accessor :req_url
    attr_reader :targer_url, :route        
    Body = Struct.new(:body, :content_type, :size, :result) 

    def initialize (requrl)
        self.req_url = requrl
        @route = "formatr"
        self.targer_url        
        @server = Body.new('','',0, 0)
        @ORS = "\r\n"
    end
    
    def targer_url
        # Get the base URL
        base = @req_url.slice(/(https?:\/\/[-a-zA-Z0-9@:%._\+~#=]{1,256}\/#{route}\/)/)
        if base == nil
            # Regex failed
            return @targer_url = nil
        end
        rsize = @req_url.size
        # Get the actual target URL that's embeded in req_url, that's after the @route
        @targer_url = @req_url.slice(base.size,rsize)
        # Patch to put missing slash in 'http:/' this means that only secure addresses are supported
        @targer_url.gsub!(/https?:\//,"https://")
    end

    def get_body(target)
        #server = Body.new('','',0)        

        URI.open(target) {|f|
            @server.content_type = f.content_type
            @server.body = f.read
        }
        @server.body << @ORS
        @server.size = @server.body.length
        @server
    end
    # The actual formatter
end
