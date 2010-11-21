module Padrino
  module Helpers
    module FormBuilder
      class SimpleFormBuilder < StandardFormBuilder
        include Padrino::Helpers::AssetTagHelpers
        include Padrino::Helpers::TagHelpers
        include Padrino::Helpers::OutputHelpers
        
        def simple_field(field, options={})
          field_output = case(options[:type])
            when :password then password_field(field, :class => :password_field)
            when :date then  date_field(field, {})
            when :select then select(field, options)
            else text_field(field, :class => :text_field)
          end
          
          label(field) + error_message_on(field) + field_output
        end
        
        def simple_submit(cancel_url)
          "<div class='group navform wat-cf'>" \
            + submit("Save", :class => :form_button) \
            + "&nbsp;&nbsp;|&nbsp;&nbsp;" + link_to ("Cancel", cancel_url, :class => :button_to) \
            + "</div>"
        end
        
        def date_field(field, options={})
          #TODO add the JS for the datepicker
          text_field(field, :class => :text_field, :"data-type" => :date)
        end
      end
    end
  end
end