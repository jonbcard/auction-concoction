module Tilt
  class PrawnTemplate < Template
    def initialize_engine
      return if defined? ::Prawn::Document
      require_template_library 'prawn'
      require_template_library 'prawn/layout'
    end

    def prepare
    end

    def evaluate(scope, locals, &block)
      pdf = ::Prawn::Document.new
      if data.respond_to?(:to_str)
        locals[:pdf] = pdf
        super(scope, locals, &block)
      elsif data.kind_of?(Proc)
        data.call(pdf)
      end
      pdf.render
    end

    def precompiled_template(locals)
      data.to_str
    end
  end
  
  register 'prawn', PrawnTemplate
end