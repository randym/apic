# Specify a route matcher to restrict which application routes are available
# in the console. By default all routes will be loaded
#
# Apic.route_matcher = /\api\/v1\//
#
#
# Specify your authentication filter. Requests that use this filter will be marked
# as restricted in the Api endpoints list.
#
Apic.authentication_filter = :authenticate
Apic.custom_headers = ['HTTP-JUST-FOR-ME']
