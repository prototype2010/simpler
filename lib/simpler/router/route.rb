module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && path.match(path_to_regexp(@path))
      end

      def match_params(env)
        params = {}
        request_path_elements = env['PATH_INFO'].split('/')
        @path.split('/').each_with_index do |param, index|
          params[param.sub(':','')] = request_path_elements[index] if param.start_with?(':')
        end
        params
      end

      private

      def path_to_regexp(path)
        regexp_body = path
          .split('/')
          .map{ |s| s.start_with?(':') ? '\d+' : s }
          .join('/')+ '(?:\/)?$'

        Regexp.new(regexp_body)
      end
    end
  end
end
