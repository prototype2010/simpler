require_relative 'config/environment'
require_relative 'middleware/logger'

use Logger
use Rack::Reloader, 0

run Simpler.application
