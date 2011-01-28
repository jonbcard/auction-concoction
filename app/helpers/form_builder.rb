module Padrino
  module Helpers
    module FormBuilder
      class SimpleFormBuilder < StandardFormBuilder
        include Padrino::Helpers::AssetTagHelpers
        include Padrino::Helpers::TagHelpers
        include Padrino::Helpers::OutputHelpers

        ##
        # Generate a field that follows simple display rules.
        #
        # Valid options:
        # :type => [password, date, select, checkbox]. If not specified, the type will default to a text field.
        #
        def simple_field(field, options={})
          field_output = case(options[:type])
            when :password then password_field(field, :class => :password_field)
            when :date then  date_field(field, {})
            when :select then select(field, options)
            when :checkbox then check_box(field, options)
            else text_field(field, :class => :text_field)
          end
          
          label(field, options) + error_message_on(field) + field_output
        end
        
        def simple_submit(cancel_url, options={})
            submit_text = options[:submit_text ]||"Save"
            submit(submit_text, :class => :form_button) \
              + "&nbsp;&nbsp;|&nbsp;&nbsp;" \
              + link_to("Cancel", cancel_url, :class => :button_to) \
        end
        
        def date_field(field, options={})
          text_field(field, :class => :text_field, :"data-type" => :date)
        end
      end
    end
  end
end