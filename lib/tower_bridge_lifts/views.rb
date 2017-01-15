
require 'json'
require 'erb'

module TowerBridgeLifts

  class View

    def render(object, command, options, format)
      options = {} if command != 'lifts'
      result = object.error || (options.empty? ? object.send(command) : object.send(command, options))
      view_name = case
        when object.error                 then 'error'
        when result.nil? || result == []  then 'empty'
        when command == 'lifts'           then ( [:lifts] + ([:group, :compact] & options.keys) ).join('_')
        when true                         then command
      end
      self.send(view_name, result, format)
    end
  
  private

    def error(result, format)
      result.to_s
    end 

    def empty(result, format)
      msg = 'no lifts scheduled'
      case format
        when :txt  then "#{msg}\n"
        when :json then [msg].to_json
        when :html then msg
      end
    end

    def status(result, format)
      case format
        when :txt  then result.map{|k,v| "#{k}: #{v}" }.join("\n")
        when :json then Hash[result.map{|k,v| [k, v.respond_to?(:to_h) ? v.to_h : v] }].to_json
        when :html then template(result, 'status.erb')
      end
    end

    def time(result, format)
      case format
        when :txt  then result
        when :json then [result].to_json
        when :html then result
      end      
    end

    def next_lift(result, format)
      case format
        when :txt  then result
        when :json then result.to_h.to_json
        when :html then result
      end
    end

    def bascules(result, format)
      case format
        when :txt  then result
        when :json then [result].to_json
        when :html then result
      end
    end

    def traffic(result, format)
      case format
        when :txt  then result
        when :json then [result].to_json
        when :html then result
      end
    end

    def lifts(result, format)
      case format
        when :txt  then result.map{ |lift| lift.to_s }.join("\n")
        when :json then result.map{ |lift| lift.to_h }.to_json
        when :html then template(result, 'lifts.erb')
      end 
    end

    def lifts_compact(result, format)
      case format
        when :txt  then result.map{ |lift| lift.date_weekday_time }.join("\n") 
        when :json then result.map{ |lift| lift.to_h }.to_json
        when :html then template(result, 'lifts_compact.erb')
      end
    end


    def lifts_group(result, format)
      case format
        when :txt  then result.map{ |k,v| [k] + (v.map{|lift| [[lift.time, lift.dir, lift.vessel].join(' ')] }) + [''] }.join("\n")
        when :json then Hash[ result.map{|date, lifts| [date, lifts.map(&:to_h)]} ].to_json
        when :html then template(result, 'lifts_group.erb')
      end
    end

    def lifts_group_compact(result, format)
      case format
        when :html then template(result, 'lifts_group_compact.erb')
        else
          result.map{ |k,v| ([k] + ["[#{v.count}]"] + (v.map{|lift| lift.time})).join(' ') }.join("\n")
        end
    end

    def template(result, name)
      ERB.new(File.read(File.join(__dir__, 'templates', name))).result(binding)
    end

  end
end