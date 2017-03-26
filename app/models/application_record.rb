class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  WORKING_HOURS = (0..23).to_a.map{|e| [e * 1.0, e+0.5]}.flatten * 2
end
