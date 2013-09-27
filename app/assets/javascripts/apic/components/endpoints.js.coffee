$.fn.extend
  endpoints: (options) ->
    settings =
      presets: {}

    self = this

    endpoints = $(self).data('endpoints')
    selected = undefined

    $.each endpoints, (key, value) ->
      $('#selectEndpoint').append('<option>'+ key + '</option>')

    change = ->
      $(self).find('.parameter').remove()
      key = $('#selectEndpoint').val()
      selected = endpoints[key]
      params = selected['parts'].concat selected['template']
      $.each params, (index, name) ->
        el = field_set_for name
        if ['DELETE', 'PATCH'].indexOf selected['verb'] >= 0
          el.find('#input-_method').val(selected['verb'].toLowerCase())

    field_set_for = (name) ->
      clone = $(self).find('.template').clone()
      label = clone.find('label')
      label.attr('for', "input-" + name)
      label.text(name)
      clone.find('input').attr('id', "input-"+name)
      clone.find('input').attr('name', name)
      clone.addClass('parameter')
      clone.removeClass('template')
      $(self).find('form').append(clone)

    $('#selectEndpoint').on 'change', -> change.apply self

    this
