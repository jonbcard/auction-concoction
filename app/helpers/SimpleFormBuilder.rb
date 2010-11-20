module Padrino
  module Helpers
    module FormBuilder
      class SimpleFormBuilder < StandardFormBuilder
        def simple_field(field, options={})
          label(field) + error_message_on(field) + text_field(field, :class => :text_field)
        end
      end
    end
  end
end