require "rjson/railtie" if defined?(Rails)

module RJSON

  # template handler
  class Handler
    class_attribute :default_format
    self.default_format = Mime::JSON

    # evals the template, then converts to an RJSONBuffer
    def call(template)
      "begin;#{template.source};end.to_rjson"
    end
  end

  # the eval'd value of a template.
  # contains the methods required to get through
  # Rails' view processing unscathed.
  class RJSONBuffer
    def initialize data
      @data = data
    end

    # called by ActionDispatch::Response to output contents,
    # passing the response itself as both arguments.
    def call a, b
      a.write @data.to_json
    end

    # when converting to JSON, return our contents.
    def as_json(options = {})
      @data
    end

    # we are already safe! pretty much.
    def html_safe
      self
    end
  end

end

class Object

  # convert to an RJSON buffer
  def to_rjson
    RJSON::RJSONBuffer.new self
  end

end
