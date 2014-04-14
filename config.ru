# config.ru
require "rubygems"
require 'rack/rewrite'
require File.expand_path("../app.rb", __FILE__)
use Rack::Rewrite do
  rewrite   '/',  '/fragd.com'
end

run Tachi::App
