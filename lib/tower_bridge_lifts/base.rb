
require 'open-uri'
require 'nokogiri'
require 'tzinfo'

module TowerBridgeLifts
  class Base
    attr_accessor :error, :updated
    attr_accessor :lifts if ENV['RACK_ENV'] == 'test'

    LIFTS_URL         =   'http://www.towerbridge.org.uk/lift-times/'
    ALLOWED_COMMANDS  =   %w(lifts next_lift bascules time traffic status server)
    EXPIRE_TIME       =   60 * 15 

                      # Lift timings (seconds)
    T_CLEAR_UP   = 60 # time to clear the bridge after the traffic is stopped
    T_MOVE_UP    = 60 # time to move the bascules up
    T_UP         = 60 # time the bridge stays open
    T_MOVE_DOWN  = 60 # time to move the bascules down
    T_CLEAR_DOWN = 60 # time to clear the bridge before traffic is allowed
    T_FULL_LIFT  = T_CLEAR_UP + T_MOVE_UP + T_UP + T_MOVE_DOWN + T_CLEAR_DOWN
    
    def initialize
      @tz      = TZInfo::Timezone.get('Europe/London')
      @lifts   = []
      @error   = nil
      @updated = nil
      fetch
    end

    def fetch
      @lifts = []
      error = nil
      page = Nokogiri::HTML(open(LIFTS_URL))
      page.css(('table tbody tr')).each do |line|  
        td = line.css('td').map{|td| td.text()}  
        @lifts << Lift.new(
          timestamp: Time.parse("#{td[1]} #{year?(td[1])} #{td[2]}"),
          vessel:    td[3],
          direction: { "Up river" => :up_river, "Down river" => :down_river }[td[4]]
        )
      end
      rescue
        error = "Unable to fetch data: #{$!}"
      ensure
        @error = error
        @updated = Time.now
    end

    def expired?
      Time.now > ( @updated + EXPIRE_TIME)
    end

    def status
      { 
        time:         time,
        lifts_count:  @lifts.count,
        next_lift:    next_lift, 
        bascules:     bascules,
        traffic:      traffic,
        updated:      @updated,
      }
    end

    def time
      @tz.now
    end

    def next_lift
      return if @lifts.empty?
      @lifts.find{ |lift| (lift.timestamp + T_FULL_LIFT) >= time }
    end
    
    def bascules
      return :down unless next_lift
      t_start = next_lift.timestamp
      t_end   = t_start + T_FULL_LIFT
      t_now   = time
      case 
        when t_now < t_start + T_CLEAR_UP                                    then :down
        when t_now >= t_end - T_CLEAR_DOWN                                   then :down
        when t_now >= t_end - T_CLEAR_DOWN - T_MOVE_DOWN                     then :moving_down 
        when t_now >= t_end - T_CLEAR_DOWN - T_MOVE_DOWN - T_UP              then :up
        when t_now >= t_end - T_CLEAR_DOWN - T_MOVE_DOWN - T_UP - T_MOVE_UP  then :moving_up
      end
    end

    def traffic
      return :allowed unless next_lift
      ( time < next_lift.timestamp ) ? :allowed : :blocked 
    end

    def lifts(options=nil)
      collection = @lifts
      return collection if collection.empty? || !options
      collection = collection.select{|lift| lift.timestamp.strftime('%d-%m-%y') == options[:date] } if options[:date]
      collection = collection[0...options[:count]] if options[:count]
      collection = collection.group_by{|lift| lift.date_weekday} if options[:group]
      collection
    end

    private

    def year?(str)
        date = Time.parse(str)
        now  = time   
        month_i(date) >= month_i(now) ? year_i(now) : (year_i(now) + 1) 
    end

    def month_i(ts)
        ts.strftime('%m').to_i
    end

    def year_i(ts)
        ts.strftime('%Y').to_i
    end

  end
end