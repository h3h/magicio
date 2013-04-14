###!
* Magicio 0.1
*
* Copyright 2013, Brad Fults - http://bradfults.com/
* Released under the MIT License
* https://github.com/h3h/magicio/LICENSE
*
* Thanks to Dave Rupert for Lettering.js
* https://github.com/davatron5000/Lettering.js
###

(($) ->
  settings = {}

  log = (msg) ->
    console?.log msg if settings.debug

  methods =
    init: (options) ->
      settings =
        requireActionOnBreak: false
        debug: false

      settings = $.extend settings, options

      @each () ->
        log "Initializing magicio for element with id \"#{@id}\""
        $(@).lettering('words').data('magicio', {thing: 'bob'})

    run: () ->
      @each () ->
        log $(@).data('magicio')

  $.fn.extend
    magicio: (method) ->
      if methods[method]
        methods[method].apply(@, Array.prototype.slice.call(arguments, 1))
      else
        methods.init.apply(@, arguments)

)(jQuery)
