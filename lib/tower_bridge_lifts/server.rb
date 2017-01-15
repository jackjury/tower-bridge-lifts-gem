require 'sinatra/base'

module TowerBridgeLifts
    class Server < Sinatra::Base

      enable :logging
    
      tblifts = Base.new
      view    = View.new

      get '/api/v1/:command' do
        content_type :json
        command = params['command']
        options = Rack::Utils.parse_query(request.query_string)
        options = Hash[ options.map{|k,v| [k.to_sym, (Integer(v) rescue v)]} ]

        if Base::ALLOWED_COMMANDS.include?(command)
          tblifts.fetch if tblifts.expired?
          view.render(tblifts, command, options, :json)
        else 
          error 404, 'oops'
        end
      end

    end
end