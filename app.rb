require 'guillotine'
require 'redis'
require 'jwt'
require 'logging'
require 'jbuilder'

require 'active_support/core_ext'

module Katana

    class App < Guillotine::App
      @@logger = Logging.logger(STDOUT)
      @@logger.level = :info
      # use redis adapter with redistogo
      uri = URI.parse(ENV["REDISTOGO_URL"])
      REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
      adapter = Guillotine::RedisAdapter.new REDIS
      set :service => Guillotine::Service.new(adapter, :strip_query => false, :strip_anchor => false)

      # authenticate everything except GETs
      before do
        unless request.request_method == "GET"
          protected!
        end
      end

      get '/' do
        "FRAGD URL SHORTENER"
      end

      post '/shorten/' do
        status, head, body = settings.service.create(params[:url], params[:code])
        callback = params[:callback]
        @@logger.info "<<<<<<<<<<<< shorten guillotine response:\n status: #{status} \n head: #{head} \n body: #{body}"
        response = shorten_response(status, head, body) 
        "#{callback}(#{response})"
      end

      get '/shorten/token/:token/ur/:url' do
        status, head, body = settings.service.create(params[:url], params[:code])
        callback = params[:callback]
        @@logger.info "<<<<<<<<<<<< shorten guillotine response:\n status: #{status} \n head: #{head} \n body: #{body}"
        shorten_response(status, head, body) 
      end

      if ENV['TWEETBOT_API']
        # experimental (unauthenticated) API endpoint for tweetbot
        get '/api/create/?' do
          status, head, body = settings.service.create(params[:url], params[:code])

          if loc = head['Location']
            "#{File.join("http://", request.host, loc)}"
          else
            500
          end
        end
      end

      # helper methods
      helpers do

        # Private: helper method to protect URLs with Rack Basic Auth
        #
        # Throws 401 if authorization fails
        def protected!
          return unless ENV["HTTP_USER"]
          unless authorized_token?
            response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
            throw(:halt, [401, "Not authorized\n"])
          end
        end

        # Private: helper method to check if authorization parameters match the
        # set environment variables
        #
        # Returns true or false
        def authorized?
          @auth ||=  Rack::Auth::Basic::Request.new(request.env)
          user = ENV["HTTP_USER"]
          pass = ENV["HTTP_PASS"]
          @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [user, pass]
        end
      end

        # Private: helper method to if decoded authorization token matches the
        # set environment variables
        #
        # Returns true or false
      def authorized_token?
        @@logger.info "<<<<<<<<<<<< #{params.inspect}"
        begin 
          JWT.decode(params[:token], ENV["JWT_SECRET"]) === ENV["JWT_ID"]
        rescue StandardError => e
          @@logger.error "<<<<<<<<<<<<  Failed Authorization: #{e}"
          return false
        end
      end

      def shorten_response(status, head, body) 
        if loc = head['Location']
          Jbuilder.encode do |json|
            json.status status
            json.head head
            json.body body
          end
        else
          Jbuilder.encode do |json|
            json.status 500
          end
        end
      end

    end
end
