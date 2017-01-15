
module Helpers

    def table_status
      @view.render(@tblifts, 'status', {}, :html)
    end

    def table_lifts
      @view.render(@tblifts, 'lifts', {}, :html)
    end

    def table_lifts_compact
      @view.render(@tblifts, 'lifts', {compact: true}, :html)
    end
    
    def table_lifts_group
      @view.render(@tblifts, 'lifts', {group: true}, :html)
    end
      
    def table_lifts_group_compact
      @view.render(@tblifts, 'lifts', {group: true, compact: true}, :html)
    end
    
end