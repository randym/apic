$(document).ready ->
  $('.http-headers').httpHeaders()
  $('.endpoints-component').endpoints()
  $('.console').apic_console(host: $('.console').data('host'))
  true
