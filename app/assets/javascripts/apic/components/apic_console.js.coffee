# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$.fn.extend
  apic_console: (options) ->
    settings =
      endpoint: '.endpoints-component'
      headers: '.http-headers'
      params: '.parameter'
      console: '.console'
      console_log: '.console-log'
      history: '.xhr-history'
      host: 'localhost:3000'
      request_timeout: 10000
      timeout_callback: null
      response_callback: null

    self = this

    history = []

    settings = $.extend settings, options

    duration = ->
      seconds = 0
      time = self._end - self._start
      try
        seconds = ((time/10) / 60).toFixed(2)
      catch e
        0
      seconds + ' seconds'

    endpoint = ->
      $(settings.endpoint).data('endpoint')

    headers = ->
      $(settings.headers).data('items')

    uri =  ->
      path  = endpoint().path
      for part in endpoint().parts
         path = path.replace(':' + part, value_for part)
       if endpoint().verb is 'GET' and query_string().lenght > 0
         path = [path, query_string()].join('?')
      path


    value_for = (name) ->
      $(settings.params + ' input[name="' + name + '"]').val()

    parameters = ->
      endpoint().template

    body = ->
      hash = {}
      $.each $(settings.params + ' input'), (index, input) ->
        name = $(input).attr 'name'
        unless endpoint().parts.indexOf(name) >= 0
          hash[name] = value_for name
      hash

    query_string = ->
      args = []
      for own key, value of body()
        args.push key + '=' + encodeURIComponent(value)
      args.join '&'

    onload = (xhr) ->
      self._end = new Date().getTime()
      request = record(xhr)
      $(settings.console_log).text JSON.stringify(request, undefined, 2)

      if xhr.status is 200
        try
          json = JSON.parse(xhr.responseText)
          text = JSON.stringify(json, undefined, 2)
        catch e
          text = xhr.responseText
        $(settings.console).text(text)
      else
        $(settings.console).text(xhr.responseText)

    onerror = (response) ->
      $(settings.console).text 'A network error has occurred. Please refresh the page and ensure that network connections to your API are possible'

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
      params = {}
      $.map $(settings.params +  " input"), (param) ->
        params[$(param).attr('name')] = $(param).val()

      history_item =
        uri: uri()
        duration: duration()
        headers: headers()
        parameters: params
        response: {status: xhr.status, statusText: xhr.statusText }
        responseHeaders: xhr.getAllResponseHeaders().split('\r\n')
        endpoint: endpoint()
      if endpoint().verb != 'GET'
        history_item['body'] = body()

      $(settings.history).trigger('add', [history_item])
      history_item

    replay = (request) ->
      r = $.extend true, {}, request
      $(settings.headers).trigger 'set', [r.headers]
      $(settings.endpoint).trigger 'set', [r.endpoint, r.parameters]
      send r.endpoint, r.headers, r.body, r.uri

    send = (_point, _head, _bod, _u) ->
      self._start = new Date().getTime()
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

    $(self).on('replay', (e, request) -> replay.apply self, [request])

    true
