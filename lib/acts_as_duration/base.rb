module ActsAsDuration
  module Base
    extend ActiveSupport::Concern
    
    included do
    end
    

    module ClassMethods
      def acts_as_duration(*base_attrs, **options)
        valid_units = [:seconds, :minutes, :hours, :days, :hhmmss]
        base_attrs.each do |base_attr|
          base_unit = options[:attr_unit] || base_attr[/(#{valid_units.join('|')})/,1].to_sym

          (valid_units - [base_unit]).each do |new_unit|
            name = base_attr.to_s.gsub!(base_unit.to_s, new_unit.to_s)
            options_hash = {name: name, base_attr: base_attr, base_unit: base_unit, new_unit: new_unit}
            define_reader_method(options_hash)
            define_writer_method(options_hash) unless options[:read_only]         
          end
        end
      end
        
      private
            
      def define_reader_method(o)
        define_method(o[:name]) do
          self.send(o[:base_attr]).send(o[:base_unit]).to_unit(o[:new_unit])
        end
      end
      
      def define_writer_method(o)
        define_method("#{o[:name]}=") do |value|
          value = o[:new_unit] == :hhmmss ? value.to_s : value.to_f
          new_value = value.send(o[:new_unit]).to_unit(o[:base_unit])
          self.send("#{o[:base_attr]}=", new_value)
        end
      end
              
    end
  end
end


ActiveRecord::Base.send :include, ActsAsDuration::Base