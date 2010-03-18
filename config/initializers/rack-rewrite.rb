require 'rack-rewrite'
ActionController::Dispatcher.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
  r301 "/proposals/", "/speakers/proposals"
  r301 "/proposals", "/speakers/proposals"
end