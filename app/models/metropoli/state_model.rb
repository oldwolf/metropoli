module Metropoli
  class StateModel < ActiveRecord::Base
    set_table_name  :states
    belongs_to      :country, :class_name => Metropoli.country_class
    has_many        :cities,  :class_name => Metropoli.city_class, :foreign_key => :state_id
    extend StatementHelper
    extend ConfigurationHelper
    
    def self.autocomplete(string='')
      string ||= ''
      state, country = string.split(',').map(&:strip)
      results = self.like(state)
      results = results.includes(:country) & country_class.like(country) unless country.blank?
      results
    end
  
    def self.like(name)
      self.where(like_statement(name))
    end
    
    def to_s
      "#{self.name}, #{self.country.abbr}"
    end
    
    def to_json
      ActiveSupport::JSON.encode(self,  :root => :state, 
                                        :except => [:id, :country_id], 
                                        :include => [:country])
    end

  end
end