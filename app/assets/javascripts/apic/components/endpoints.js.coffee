$.fn.extend
  endpoints: (options) ->
    settings =
      select: '#selectEndpoint',
      template: '.template',
      parameter: '.parameter'

    self = this

    settings = $.extend settings, options

    endpoints = $(self).data('endpoints')

    $.each endpoints, (key, value) ->
      option = $('<option>'+ key + '</option>')
      console.log value
      option.text('[restricted] ' + option.text()) if value.authorization_required
      $(settings.select).append(option)

    change = ->
      endpoint = selected()
      $(self).data('endpoint', endpoint)
      populate_params endpoint

    populate_params = (endpoint) ->
      $(self).find(settings.parameter).remove()
      $.each endpoint.parts, (index, name) ->
        field_set_for name, {required: true}
      $.each endpoint.template, (index, name) ->
        el = field_set_for name
        if ['DELETE', 'PATCH'].indexOf endpoint.verb >= 0
          el.find('#input-_method').val(endpoint.verb.toLowerCase())

    selected = ->
      endpoints[$(settings.select).val()]

    field_set_for = (name, options={}) ->
      clone = $(self).find(settings.template).clone()
      label = clone.find('label')
      label.attr('for', "input-" + name)
      label.text(name)
      clone.find('input').attr('id', "input-"+name)
      clone.find('input').attr('name', name)
      clone.addClass(settings.parameter.slice(1))
      clone.removeClass(settings.template.slice(1))
      if options.required
        clone.find('input').prop('required',true)
      $(self).find('form').append(clone)

    $(settings.select).on 'change', -> change.apply self
    change.apply self

    this
