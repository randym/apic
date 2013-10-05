
$.fn.extend

  xhr_history: (options) ->
    defaults = {}
    self = this
    $(self).data('items', [])

    refresh = ->
      $(self).empty()
      $.each items(), (index, item) ->
        el = list_item(item)
        el.data('request', item)

        $(self).append el

    list_item = (item) ->
      $('<li class="xhr-history-item ' + item.xhr.statusText.toLowerCase() + '"><a href="#"><i class="icon-refresh icon-white ' + item.xhr.statusText.toLowerCase() + '"/><i>' + item.xhr.status + ' '+ item.endpoint.verb + ' ' + item.uri + '</span></a></li>')

    items = ->
      $(self).data('items')

    add = (item)->
      i = items()
      i.push item
      $(self).data('items',i)
      refresh()

    replay = (el) ->
      request = $(el).data('request')
      $('.console').trigger('send', [request.endpoint, request.headers, request.body, request.uri])
      console.log($(el).data('request'))

    show = ->
      el = $('.history')
      el.toggle()

      li = $(event.target).closest('li')
      if $(el).is(':visible')
        li.addClass('active')
      else
        li.removeClass('active')

    $(self).on('refresh', -> refresh.apply self)
    $(self).on('add', (e, item) -> add.apply self, [item])
    $('.xhr-history').on('click', 'li', (e) -> replay this)
    $('.toggle-history').on('click', -> show.apply self)

    this
