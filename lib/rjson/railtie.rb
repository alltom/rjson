module RJSON
  class Railtie < Rails::Railtie

    # register .rjson extension for RJSON views
    initializer "rjson.configure_rails_initialization" do
      ActionView::Template.register_template_handler(:rjson, RJSON::Handler.new)
    end

  end
end
