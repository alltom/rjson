# registers .rjson extension for RJSON views
ActionView::Template.register_template_handler(:rjson, RJSON::Handler.new)
