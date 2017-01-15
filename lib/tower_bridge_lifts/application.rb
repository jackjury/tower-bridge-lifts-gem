
require 'optparse'

module TowerBridgeLifts
  class Application

    def run
        options = {}
        parser = OptionParser.new do |opt|
        opt.banner = ""
        opt.separator "Tower Bridge Lifts - provides lift times information, parsed from towerbridge.org.uk"
        opt.separator ""
        opt.separator "Usage:"
        opt.separator " tblifts [COMMAND] [OPTIONS]"
        opt.separator ""
        opt.separator "Commands:"
        opt.separator "     <none> | lifts      shows all scheduled lifts"
        opt.separator "     next | next_lift    shows the next lift only"
        opt.separator "     bascules            shows the bascules position"
        opt.separator "     time                shows local time (London)"
        opt.separator "     traffic             shows traffic status accross the bridge"
        opt.separator "     status              shows all above"
        opt.separator "     server              serves an api in server mode"
        opt.separator ""
        opt.separator "Options:"

        opt.on('-d', '--date=date'  , 'filter by date (DD-MM-YY | today | tomorrow)') do |date|
          date = Time.now.strftime('%d-%m-%y') if date == 'today'
          date = (Time.now + 24*60*60).strftime('%d-%m-%y') if date == 'tomorrow' 
          options[:date] = date 
        end
        opt.on('-c', '--compact'    , 'shows compact') {options[:compact] = true}
        opt.on('-g', '--group'      , 'group lifts by date') {options[:group] = true}
        opt.on('-l', '--lines=num'  , 'lines to display') {|num| options[:count] = num.to_i }
        opt.separator ""
        opt.on('-p', '--port=port'  , 'sets the port on server mode') {|port| options[:port] = port.to_i}
        opt.separator ""
        opt.on('-h', '--help'       , 'displays help') { puts opt; exit }
        opt.on('-v', '--version'    , 'displays version') { puts TowerBridgeLifts::VERSION; exit }
        opt.separator ""
        opt.separator "For more info, please visit http://github.com/aaparmeggiani/tower_bridge_lifts"
        opt.separator "" 
        end

        begin
          parser.parse!
        rescue OptionParser::InvalidOption, OptionParser::MissingArgument 
          puts "#{$!.to_s.capitalize}\n"                                                           
          exit                                              
        end 

        if DEBUG
          puts "command: #{command}"
          puts "options: #{options}"
          puts "----"
        end

        command = case ARGV[0]
          when nil    then 'lifts'
          when 'next' then 'next_lift'
          else ARGV[0]
        end

        unless Base::ALLOWED_COMMANDS.include?(command)
          puts "Unknown Command: #{command}"
          exit
        end

        if command == 'server'
          Server.run!(port: options[:port])
        else
          puts View.new.render(Base.new, command, options, :txt)
        end

    end
  end  
end

