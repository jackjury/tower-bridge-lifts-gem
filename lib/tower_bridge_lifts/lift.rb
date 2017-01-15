
module TowerBridgeLifts
  class Lift
    attr_accessor :timestamp, :vessel, :direction

    def initialize(timestamp: nil, vessel: nil, direction: nil )
        raise "Hey!!" if timestamp.nil? 
        @timestamp, @vessel, @direction = timestamp, vessel, direction
    end

    def to_s
      [ date_weekday_time, dir, vessel ].join(' ') 
    end

    def to_h
      Hash[ instance_variables.map{|v| [v[1..-1].to_sym, instance_variable_get(v)]} ]
    end

    def empty?
      false
    end

    ### Decorators
    def date
      timestamp.strftime('%d-%b-%y')
    end

    def weekday
      timestamp.strftime('%a')
    end

    def time
      timestamp.strftime('%H:%M') 
    end

    def date_weekday
      [date, weekday].join(' ')
    end

    def date_weekday_time
      [date, weekday, time].join(' ')
    end

    def dir
      { :up_river => "⬆︎", :down_river => "⬇︎" }[@direction]
    end

  end
end