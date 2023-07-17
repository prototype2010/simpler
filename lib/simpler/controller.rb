require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @body_written = false
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)

      write_from_convention_template unless @body_written

      @response.finish
    end

    def append_path_params(params)
      @request.params.merge!(params)
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_from_convention_template
      body = render_body

      @response.write(body)
      @body_written = true
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      case template
      when String
        proceed_string_template(template)
      when Hash
        proceed_hash_options(template)
      else
        template_error("Template can be string or hash, but not #{template.class}.")
      end

      @body_written = true
    end

    def proceed_string_template(template)
      @request.env['simpler.template'] = template
    end

    def proceed_hash_options(options)
      if options.key?(:plain)
        @response.write(options[:plain].to_s)
      else
        template_error("Applying options #{options.keys} is not implemented yet")
      end
    end

    def template_error(message)
      @response.status = 500
      @response.write(message)
      @response.finish
    end

    def status(status)
      puts('Status has already been set before setting') if @response.status

      response.status = status
    end

    def headers
      @response.headers
    end
  end
end
