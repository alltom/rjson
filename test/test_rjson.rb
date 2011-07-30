require "helper"
require "action_dispatch/http/mime_type"
require "active_support/json"
require "active_support/core_ext/object/conversions" # rails ticket https://gist.github.com/971766

# mocks ActionDispatch::response
class FakeResponse
  attr_reader :data

  def initialize
    @data = ""
  end

  def write new_data
    data << new_data
  end
end

class TestRjson < Test::Unit::TestCase
  def test_buffer_converts_to_json
    data = { :a => :b }
    assert_equal data.to_json, RJSON::RJSONBuffer.new(data).to_json
  end

  def test_buffer_is_html_safe
    data = { :a => :b }
    buffer = RJSON::RJSONBuffer.new(data)
    assert_equal buffer, buffer.html_safe
  end

  def test_buffer_writes_to_response_object
    data = { :a => :b }
    buffer = RJSON::RJSONBuffer.new(data)
    fake_response = FakeResponse.new
    buffer.call(fake_response, fake_response)
    assert_equal buffer.to_json, fake_response.data
  end

  def test_can_create_rjson_buffer_with_to_rjson
    data = { :a => :b }
    rjson = data.to_rjson
    assert RJSON::RJSONBuffer === rjson
  end

  def test_buffer_returns_original_data_from_as_json
    data = { :a => :b }
    rjson = data.to_rjson
    assert_equal data, rjson.as_json
  end

  def test_handler_has_default_format
    assert_equal Mime::JSON, RJSON::Handler.default_format
  end

  def test_handles_template
    fake_template = Object.new
    def fake_template.source
      "{ :a => :b }"
    end
    output = eval(RJSON::Handler.new.call(fake_template))
    assert RJSON::RJSONBuffer === output
    assert_equal ({ :a => :b }.to_json), output.to_json
  end

  # TODO: test that partials work (how?)
  # TODO: test that layouts work (how?)
end
