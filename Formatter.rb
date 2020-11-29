class Formatter
    attr_accessor :req_url
    attr_reader :targer_url      
    Body = Struct.new(:body, :content_type, :size, :result) 

    def initialize (requrl = "")
        self.req_url = requrl        
        @server = Body.new('','',0, 0)
        @ORS = "\r\n"
    end
    
    def targer_url(requrl = @req_url)
        puts "@requrl: #{@req_url}"
        # Get the base route
        base = requrl.slice(/^\/[-a-zA-Z0-9@:%._\+~#=]{1,256}\//)
        if base == nil
            # Regex failed
            @targer_url = nil
            return @targer_url
        end
        @targer_url = req_url.delete_prefix(base)
    end

    def get_body(target)
        begin
            URI.open(target) {|f|
                @server.content_type = f.content_type
                @server.body = f.read
            }
        rescue Exception => e
            @server.body = nil
            @server.result = e.message
            return @server
        end
        @server.body << @ORS
        @server.size = @server.body.length
        @server.result = "OK"
        @server
    end
    
    def format_body(rules, body)
        rules.each_pair do |exp, newv|
            body.gsub!(exp, newv)
        end
        body
    end
end
