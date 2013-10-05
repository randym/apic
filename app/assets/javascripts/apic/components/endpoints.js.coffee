$.fn.extend
  endpoints: (options) ->
    settings =
      select: '#selectEndpoint',
      template: '.template',
      parameter: '.parameter',
      restricted: '[restricted] '

    self = this

    settings = $.extend settings, options

    endpoints = $(self).data('endpoints')

    $.each endpoints, (key, value) ->
      option = $('<option>'+ key + '</option>')
      option.text(settings.restricted + option.text()) if value.authentication_required
      $(settings.select).append(option)

    add = (name) ->
      if !!name
        el = field_set_for name
        $(el).find('.icon-remove').removeClass('hide')
        $(el).find('.remove-parameter').on('click', -> remove.apply self, [el])
        $('#endpointsModal').modal('hide')

    create = ->
      $('#inputParameterFieldName').val('')
      $('#endpointsModal').modal('show')

    remove = (el) ->
      el.remove()

    change = ->
      endpoint = selected()
      $(self).data('endpoint', endpoint)
      populate_params endpoint

    set = (point, param) ->
      option = if point.authentication_required then settings.restricted + point.key else point.key
      $(settings.select).val(option)

      change()

      $.each param, (key, value) ->
        add(key) if $('input[name="' + key + '"]').length == 0
        field = $('input[name="' + key + '"]')
        $(field).val(value)

    populate_params = (endpoint) ->
      $(self).find(settings.parameter).remove()
      $.each endpoint.parts, (index, name) ->
        field_set_for name, {required: true}
      $.each endpoint.template, (index, name) ->
        el = field_set_for name
        if ['DELETE', 'PATCH'].indexOf endpoint.verb >= 0
          el.find('#input-_method').val(endpoint.verb.toLowerCase())

    selected = ->
      endpoints[$(settings.select).val().replace(settings.restricted, '')]

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
      clone

    $(settings.select).on 'change', -> change.apply self
    $('.create-parameter').on 'click', -> create.apply self
    $('.add-parameter').on 'click', -> 
      add.apply self, [$('#inputParameterFieldName').val()]

    $(self).on 'set', (e, point, params) -> set.apply self, [point, params]
    change.apply self

    this
