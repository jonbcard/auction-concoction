module MongoMapper
  module Plugins
    module CustomFieldPlugin

      module ClassMethods
        def validate_custom
          validate :validate_custom_required
        end
      end

      module InstanceMethods

        def custom_fields
          _customization.custom_fields
        end

        def validate_custom_required
          _customization.required_fields.each do |field |
            val = eval field.field
            errors.add(field.field.intern, "can't be empty") if val.nil? || val.empty?
          end
        end

        def _customization
          @_customization = Customization.get_by_model(self)
        end
      end
      
    end
  end
end