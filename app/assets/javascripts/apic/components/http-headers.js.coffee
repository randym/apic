# Plugin for adding and removing HTTP headers
# a name value pair for now - can we validate? 
# should we?
$.fn.extend
  httpHeaders: (options) ->
    settings =
      presets: {}
      debug: false

    $.each $(this).data(), (key, value) ->
      settings[key] = value

    settings = $.extend settings, options

    self = this
    selected = undefined

    $(this).data('items', settings.presets)

    add = ->
      name = $('#inputHttpHeaderName').val()
      value = $('#inputHttpHeaderValue').val()
      if !!name or  !!value
        tmp_items = items()
        tmp_items[name] = value
        $(self).data('items', tmp_items)
        populate()
        $('#httpHeadersModal').modal('hide')
      else
        alert('wha?')

    remove = ->
      if self.selected
        headers = items()
        delete headers[self.selected.data('key')]
        $(self).data('items', headers)
        self.selected.remove()
        self.selected = undefined
        populate()

    edit = ->
      event.stopPropagation()
      name = self.selected.data('key')
      headers = items()
      value = headers[name]
      $('#inputHttpHeaderName').val(name)
      $('#inputHttpHeaderValue').val(value)
      $('#httpHeadersModal').modal('show')

    create = ->
      $('#inputHttpHeaderName').val('')
      $('#inputHttpHeaderValue').val('')
      $('#httpHeadersModal').modal('show')

    show = ->
      $('.http-headers-component').toggle()

    list = ->
      $(self).find('ul')

    items = ->
      $(self).data('items')


    populate = ->
      list().empty()
      $.each items(), (key, value) ->
        list().append('<li class="http-header-item" data-key="' + key + '"><a href="#"><span class="header-key">' + key + ':</span><span class="header-value">' + value + '</span></a></li>')
      select list().find('li:first')


    select = (el) ->
      $.each $('.http-headers-list li'), (index, el) ->
        $(el).removeClass('active')

      $(el).addClass('active')
      self.selected = $(el)

    populate()

    $('#httpHeadersModal a.add-http-header').on('click', -> add.apply self)
    $('.create-http-header').on('click', -> create.apply self)

    $('.remove-http-header').on('click', -> remove.apply self)
    $('.http-headers-list').on('click', 'li', -> select this)
    $('.http-headers-list').on('dblclick', 'li', -> edit.apply self)
    $('.edit-headers').on('click', -> show.apply self)
    this


