# config.ru
require "rubygems"
require 'rack/rewrite'
require File.expand_path("../app.rb", __FILE__)
use Rack::Rewrite do
  r301 '/', 'https://www.fragd.com/'
end

run Tachi::App
