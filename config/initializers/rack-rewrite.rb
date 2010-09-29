require 'rack-rewrite'
ActionController::Dispatcher.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
  # Redirect all requests to live.ignitebaltimore.com to the live stream
  r302 /.*/, "http://www.livestream.com/ignitebmore", :if => Proc.new { |rack_env|
    rack_env['SERVER_NAME'] == 'live.ignitebaltimore.com'
  }
  r301 "/proposals/", "/speakers/proposals"
end
