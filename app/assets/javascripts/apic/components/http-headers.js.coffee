$.fn.extend
  httpHeaders: (options) ->
    defaults =
      presets: {'Content-Type': 'application/json'},
      headers: [
        'Accept',
        'Accept-Charset',
        'Accept-Datetime',
        'Accept-Encoding',
        'Accept-Language',
        'Authorization',
        'Cache-Control',
        'Connection',
        'Content-Length',
        'Content-MD5',
        'Content-Type',
        'Cookie',
        'Date',
        'Expect',
        'From',
        'Host',
        'If-Match',
        'If-Modified-Since',
        'If-None-Match',
        'If-Range',
        'If-Unmodified-Since',
        'Max-Forwards',
        'Origin',
        'Pragma',
        'Proxy-Authorization',
        'Range',
        'Referer',
        'TE',
        'Upgrade',
        'User-Agent',
        'Via',
        'Warning'
      ]

    $.each $(this).data(), (key, value) ->
      defaults[key] = $.extend defaults[key], value

    settings = $.extend defaults, options

    $(this).data('items', settings.presets)

    self = this

    $('#inputHttpHeaderFieldName').typeahead({source: settings.headers})
    selected = undefined

    add = ->
      name = $('#inputHttpHeaderFieldName').val()
      value = $('#inputHttpHeaderValue').val()
      if !!name and !!value
        tmp_items = items()
        tmp_items[name] = value
        $(self).data('items', tmp_items)
        populate()
        $('#httpHeadersModal').modal('hide')

    remove = ->
      if self.selected
        headers = items()
        delete headers[self.selected.data('key')]
        $(self).data('items', headers)
        self.selected.remove()
        self.selected = undefined
        populate()

    edit = ->
      name = self.selected.data('key')
      headers = items()
      value = headers[name]
      $('inputHttpHeaderFieldName').val(name)
      $('#inputHttpHeaderValue').val(value)
      $('#httpHeadersModal').modal('show')

    create = ->
      $('#inputHttpHeaderFieldName').val('')
      $('#inputHttpHeaderValue').val('')
      $('#httpHeadersModal').modal('show')

    show = ->
      el = $('.headers')
      el.toggle()

      li = $(event.target).closest('li')
      if $(el).is(":visible")
        li.addClass('active')
      else
        li.removeClass('active')

    list = ->
      $(self).find('ul')

    items = ->
      $(self).data('items')


    populate = ->
      list().empty()
      $.each items(), (key, value) ->
        list().append(list_item(key, value))
      select list().find('li:first')


    select = (el) ->
      $.each $('.http-headers-list li'), (index, el) ->
        $(el).removeClass('active')

      $(el).addClass('active')
      self.selected = $(el)

    list_item = (key, value)->
      '<li class="http-header-item" data-key="' + key + '">' +
      '<a href="#"><span class="header-key">' + key + ':</span>' +
      '<span class="header-value">' + value + '</span></a></li>'

    populate()

    $('#httpHeadersModal a.add-http-header').on('click', -> add.apply self)
    $('.create-http-header').on('click', -> create.apply self)

    $('.remove-http-header').on('click', -> remove.apply self)
    $('.http-headers-list').on('click', 'li', -> select this)
    $('.http-headers-list').on('dblclick', 'li', -> edit.apply self)
    $('.edit-headers').on('click', -> show.apply self)

    this


