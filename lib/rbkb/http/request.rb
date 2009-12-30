module Rbkb::Http

  # A Request encapsulates all the entities in a HTTP request message
  # including the action header, general headers, and body.
  class Request < Base
    def action
      @action ||= RequestAction.new
    end

    def action=(a)
      @action = a
    end

    alias first_entity action
    alias first_entity= action=

    def action_parameters
      action.parameters
    end
    
    def body_parameters
      ctype, ct_parms = @headers.get_parameterized_value('Content-Type')
      case ctype
      when /^application\/(?:x-)?(?:www-form-url|url-)encoded(?:\W|$)/
        FormUrlencodedParams.new(@body)
      when /^multipart\/form-data$/
        MultipartFormParams.new(@body, :boundary => ct_parms.get_value_for('boundary'))
      when /^text\/plain$/
        # safari just gives us url-encoded parameters for text/plain.
        # Joy!
        if @headers.get_value_for('User-Agent') =~ /\WSafari\W/
          FormUrlencodedParams.new(@body)
        else
          TextPlainFormParams.new(@body)
        end
      end
    end

    # Returns a new Headers object extended as RequestHeaders. This is the 
    # default object which will be used when composing fresh Request header
    # entities.
    def default_headers_obj(*args)
      Headers.new(*args).extend(RequestHeaders)
    end

    # Returns a new BoundBody object. This is the default object which will 
    # be used when composing fresh Request body entities.
    def default_body_obj(*args)
      Body.new(*args)
    end

    # Returns a raw HTTP request for this instance. 
    def to_raw()
      self.headers ||= default_headers_obj()
      self.body ||= default_body_obj()

      if len=@opts[:static_length]
        @body = Body.new(@body, @body.opts) {|x| x.base = self}
        @headers.set_header("Content-Length", len.to_i)
      elsif @opts[:ignore_content_length]
        @headers.delete_header("Content-Length")
      end

      bstr = @body.to_raw
      hdrs = @headers.to_raw_array.unshift(first_entity.to_raw)
      return "#{hdrs.join("\r\n")}\r\n\r\n#{bstr}"
    end


    # Parses a raw HTTP request and captures data into the current instance.
    def capture(str)
      raise "arg 0 must be a string" unless String === str
      hstr, bstr = str.split(/\s*\r?\n\r?\n/, 2)
      capture_headers(hstr)
      self.body = content_length ? BoundBody.new : Body.new
      capture_body(bstr)
      return self
    end
  end
end
