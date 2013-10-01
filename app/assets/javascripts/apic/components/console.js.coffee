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
      host: 'localhost:3000',
      request_timeout: 10000,
      timeout_callback: null,
      response_callback: null

    self = this

    settings = $.extend settings, options

    log_timeline = (method, uri) ->
      self._end = new Date().getTime()
      if console.log
        console.log 'Finished: (time: ' + duration() + '):' + method + ' ' + uri

    log_request = (xhr)  ->
      self._start = new Date().getTime()
      console.log xhr
      log_message "Request URL", uri()
      log_message "Request Method", endpoint().verb
      log_message "Response Code", [xhr.status, xhr.statusText].join(' ')
      log_message "Request Headers", xhr.getAllResponseHeaders()

    log_message = (title, message) ->
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

    $('#do-me').on('click', -> send.apply self)

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

    onerror = (response) ->
      console.log response

    request = () ->
      xhr = new XMLHttpRequest
      xhr.open endpoint().verb, uri()
      set_headers xhr
      xhr.onerror = (xhr) ->
        onerror.apply self, [xhr]
      xhr.onload = (response) ->
        onload.apply self, [xhr]
      xhr

    set_headers = (xhr) ->
      $.each headers(), (key, value) ->
        xhr.setRequestHeader(key, value)

    validate_params = () ->
      missing =[]
      for part in endpoint().parts
        if value_for(part) is ""
          missing.push(part)
        if missing.length > 0
          alert('url parts reqired: ' + missing)
      missing.length is 0

    send = () ->
      if validate_params()
        xhr = request()
        if endpoint().verb is 'GET'
          xhr.send()
        else
          xhr.send JSON.stringify(body)
