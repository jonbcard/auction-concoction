module MongoMapper
  module Plugins
    module CustomFieldPlugin

      module ClassMethods
        def custom_fields(name)
          custom = Customization.first_or_create(params[:model])
          custom.custom_fields.each {|field| key field.field, String }
        end
      end

      module InstanceMethods
        def get_custom_fields
          Customization.first_or_create("bidder").custom_fields
        end
      end
      
    end
  end
end