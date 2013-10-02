# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$.fn.extend
  apic_console: (options) ->
    settings =
      endpoint: '.endpoints-component',
      headers: '.http-headers',
      params: '.parameter',
      console: '.console',
      console_log: '.console-log',
      history: '.xhr-history',
      host: 'localhost:3000',
      request_timeout: 10000,
      timeout_callback: null,
      response_callback: null

    self = this

    history = []

    settings = $.extend settings, options

    log_timeline = (method, uri) ->
      self._end = new Date().getTime()
      if console.log
        console.log 'Finished: (time: ' + duration() + '):' + method + ' ' + uri

    log_request = (xhr)  ->
      self._start = new Date().getTime()

      $(settings.console_log).empty()
      log_item "Request URL", uri()
      log_item "Request Method", endpoint().verb
      log_item "Response Code", [xhr.status, xhr.statusText].join(' ')
      log_item "Request Headers", xhr.getAllResponseHeaders()

    log_item = (title, message) ->
      $(settings.console_log).append('<div><span class="log-header">' + title + '</span>:<span class="log-data"> ' + message + '</span></div>')

    duration = ->
      seconds = 0
      time = _end - _start
      try
        seconds = ((time/10) / 60).toFixed(2)
      catch e
        0
      seconds

    endpoint = ->
      $(settings.endpoint).data('endpoint')

    headers = ->
      $(settings.headers).data('items')

    uri =  ->
      path  = endpoint().path
      for part in endpoint().parts
         path = path.replace(':' + part, value_for part)
      if endpoint().verb is 'GET'
        path += query_string()
      path


    value_for = (name) ->
      $(settings.params + ' [name="' + name + '"]').val()

    parameters = ->
      endpoint().template

    body = ->
      hash = {}
      for param in parameters()
        hash[param] = value_for param
      hash

    query_string = ->
      args = []
      for own key, value of body()
        args.push key + '=' + encodeURIComponent(value)
      args.join '&'

    onload = (xhr) ->
      if xhr.status is 200
        try
          json = JSON.parse(xhr.responseText)
          text = JSON.stringify(json, undefined, 2)
        catch e
          text = xhr.responseText
        $(settings.console).text(text)
      else
        $(settings.console).text(xhr.responseText)

      log_request xhr
      record(xhr)

    onerror = (response) ->
      console.log response

    request = (endpoint, headers, uri) ->
      xhr = new XMLHttpRequest
      xhr.open endpoint.verb, uri, true
      $.each headers, (key, value) ->
        if key is 'Authorization'
          xhr.withCredentials = true
        xhr.setRequestHeader(key, value)

      xhr.onerror = (xhr) ->
        onerror.apply self, [xhr]
      xhr.onload = (response) ->
        onload.apply self, [xhr]
      xhr

    set_headers = (xhr) ->
      $.each headers(), (key, value) ->
        if key is 'Authorization'
          xhr.withCredentials = true
        xhr.setRequestHeader(key, value)

    validate_params = () ->
      missing =[]
      for part in endpoint().parts
        if value_for(part) is ""
          missing.push(part)
      if missing.length > 0
        alert('url parts reqired: ' + missing)
      missing.length is 0

    record = (xhr) ->
      history_item =
        endpoint: endpoint()
        headers: headers()
        body: body()
        uri: uri()
        xhr: xhr

      $(settings.history).trigger('add', [history_item])

    send = (_point, _head, _bod, _u) ->
      _point ||= endpoint()
      _head ||= headers()
      _bod ||= body()
      _u ||= uri()

      if validate_params()
        xhr = request(_point, _head, _u)
        if _point.verb is 'GET'
          xhr.send()
        else
          data = JSON.stringify(_bod)
          xhr.send(data)

    $('#do-me').on('click', -> send.apply self, [null])
    $(self).on('send', (e, point, head, bod, u) -> send.apply self, [point, head, bod, u])
    true
