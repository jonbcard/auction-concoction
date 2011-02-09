require 'mongo_mapper/plugins/keys/key'

module MongoMapper
  module Plugins
    module MetaData

      module ClassMethods
        def required_fields
          @_required_fields ||= []
        end

        def required_field?(field_name)
          required_fields.include?(field_name)
        end

        ##
        # Overrides the method in order to add tracking of required fields as class
        # meta-data. This meta-data can be used for rendering purposes, etc.
        #
        def validates_presence_of(*args)
          args.each do |attribute|
            unless attribute.is_a?(Hash)
              self.required_fields << attribute
            end
          end
          add_validations(args, Validatable::ValidatesPresenceOf)
        end
      end

      module InstanceMethods
      
      end

    end
  end
end
