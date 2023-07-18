class Logger
  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env
    status, headers, body = @app.call(env)

    log_entry = make_log_item(status, headers, body)
    log(log_entry)

    [status, headers, body]
  end

  def log(log_ingo)
    filename = "#{Time.new.strftime('%d-%m-%Y')}.txt"
    filepath = File.expand_path("log/#{filename}")

    File.write(filepath, log_ingo, mode: File.exist?(filepath) ? 'a' : 'w')
  end

  def make_log_item(status, headers, _body)
    response_info = collect_response_info
    "
    Request: #{@env['REQUEST_METHOD']} #{@env['REQUEST_METHOD']}
    Handler: #{response_info[:controller]}##{response_info[:action]}
    Parameters: #{query_string_parameters.merge(parameters)}
    Response: #{status} [#{headers['Content-Type']}] #{response_info[:template]}"
  end

  def collect_response_info
    controller = env['simpler.controller'].class.name
    action = env['simpler.action']
    parameters = env['matched.params'].merge(Rack::Utils.parse_query(env['QUERY_STRING']))
    template = env['simpler.template'] || env['simpler.render']

    { controller: controller, action: action, parameters: parameters, template: template }
  end
end
