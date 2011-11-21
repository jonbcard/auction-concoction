module Padrino
  module Helpers
    module FormBuilder
      class KOFormBuilder < StandardFormBuilder
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
          required = @object && @object.class.respond_to?(:required_field?) ? @object.class.send(:required_field?, field) : false
          add_css_class(options, :required) if required

          field_output = case(options[:type])
            when :password then password_field(field, :class => :password_field)
            when :date then  date_field(field, options)
            when :select then select(field, options)
            when :checkbox then check_box(field, options)
            else
              add_css_class(options, :text_field)
              text_field(field, options)
          end

          label_options = options.include?(:caption) ? {:caption => options[:caption]} : {}
          label(field, label_options) + error_message_on(field) + field_output
        end
        
        def simple_submit(cancel_url, options={})
            submit_text = options[:submit_text ]||"Save"
            submit(submit_text, :class => :form_button) \
              + "&nbsp;&nbsp;|&nbsp;&nbsp;" \
              + link_to("Cancel", cancel_url, :class => :button_to) \
        end
        
        def date_field(field, options={})
          options.merge! :"data-type" => :date
          add_css_class(options, :text_field)
          text_field(field, options)
        end

        private
          ##
          # Add a CSS class to the given options
          #
          def add_css_class(options, css_class)
            if options.include?(:class)
              options[:class] = options[:class].to_s + " #{css_class}"
            else
              options[:class] = css_class
            end
          end
      end
    end
  end
end