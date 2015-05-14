# Requires
Handlebars = require 'handlebars'
webutils = require './webutils'
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
util = require 'util'
extend = require 'extend'

Formutils = {

  form: (method, action, title, controls) ->
    form = """
              <div class="box box-primary">
              <div class="box-header">
                  <h3 class="box-title">#{title}</h3>
              </div><!-- /.box-header -->
              <form method="#{method}" action="#{action}" role="form">
              <div class="box-body">
            """
    for c in controls
      form += Formutils.control c
    form += """<div class="box-footer">
                  <button type="submit" class="btn btn-primary">Submit</button>
                </div>"""
    form += Formutils.control { type: 'hidden', name: 'csrf', value: webutils.csrfToken() }
    form = form + "</form></div></div><!-- /.box -->"
    return form

  control: (c) ->
    if typeof(c.value) == 'undefined'
      c.value = ""

    if c.type == 'hidden'
      return """<input type="hidden" name="#{c.name}" value="#{c.value}" />"""
    if c.type == 'text'
      return """<div class="form-group"><label>#{c.label}</label><br /><input type="text" name="#{c.name}" value="#{c.value}" placeholder="#{c.placeholder}" /></div>"""
    if c.type == 'textarea'
      return """<div class="form-group"><label>#{c.label}</label><br /><textarea name="#{c.name}" class="form-control" rows="3"></textarea></div>"""

}

module.exports = Formutils
