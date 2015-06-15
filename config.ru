$stdout.sync = true
$:.unshift File.dirname(__FILE__) + '/lib'
require 'descartes/web'
require 'descartes/github_auth'
require 'rack-canonical-host'

use Rack::CanonicalHost do
  case ENV['RACK_ENV'].to_sym
    when :production then ENV['CANONICAL_HOST'] if defined?ENV['CANONICAL_HOST']
  end
end

use Rack::Session::Cookie, :key => 'rack.session',
  :expire_after => 1209600,
  :secret => (ENV['SESSION_SECRET'] || raise('missing SESSION_SECRET'))

use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {
    :name => "google",
    :hd => ENV["GOOGLE_OAUTH_DOMAIN"]
  }
end

run Rack::URLMap.new('/' => Descartes::Web, '/auth/github' => Descartes::GithubAuth)

# seed our Metrics list at startup
Metric.load unless ENV['METRICS_UPDATE_ON_BOOT'] == 'false'

# update our Metrics list at regular intervals
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.new
# kick off update after we start so as not to hit Heroku's web startup timeout
scheduler.in '1m' do
  Metric.update
end
scheduler.every ENV['METRICS_UPDATE_INTERVAL'] do
  Metric.update
end
