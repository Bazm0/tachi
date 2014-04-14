# config.ru
require "rubygems"
require 'rack/rewrite'
require File.expand_path("../app.rb", __FILE__)
use Rack::Rewrite do
  r301 '/', ENV["ROOT_DOMAIN"]
end

run Tachi::App
