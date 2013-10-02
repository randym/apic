$(document).ready ->
  $('.http-headers').httpHeaders()
  $('.endpoints-component').endpoints()
  $('.console').apic_console(host: $('.console').data('host'))
  $('.xhr-history').xhr_history()
  true
