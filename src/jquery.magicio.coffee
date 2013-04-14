###!
* Magicio 0.1
*
* Copyright 2013, Brad Fults - http://bradfults.com/
* Released under the MIT License
* https://github.com/h3h/magicio/LICENSE
*
* Thanks to Dave Rupert for inspiration from Lettering.js
* https://github.com/davatron5000/Lettering.js
###

(($) ->
  settings = {}
  UNIQUE_STR = "eefec303079ad17405c889e092e105b0"

  log = (msg, others...) ->
    if settings.debug
      if others.length then console?.log(msg, others) else console?.log(msg)

  class Action
    constructor: (@nextElement, @prevElement, @breakClasses, @breakType, @timing) ->

  methods =
    init: (options) ->
      settings =
        debug: false
        defaultActionOnPause: 'time'

      settings = $.extend settings, options

      @each () ->
        log "Initializing Magicio for element with id \"#{@id}\""
        jqEl = $(@)
        methods.parse(jqEl)
        #methods.buildActions(jqEl)

    destroy: (jqEl) ->
      @each () ->
        log "Destroying Magicio for element with id \"#{@id}\""
        $(@).removeData('magicio')

    buildActions: (jqEl) ->
      jqEl.data('magicio', {actions: actions})

    parse: (jqEl) ->
      jqEl.trigger('beforeparse')

      # First parse & tag explicit breaks
      breaks = jqEl.children('.m-break')
      log "Breaks: #{breaks.length}"
      if breaks.length is 0
        breaks = jqEl
      else
        breaks.addClass('m-break-parsed')

      # Then parse, wrap & tag explicit pauses
      breaks.each () ->
        elBreak = $(@)
        pauses = elBreak.children('br.m-pause')
        log "Pauses: #{pauses.length}"
        pauses.replaceWith(UNIQUE_STR)
        fragments = elBreak.html().split(UNIQUE_STR)
        if fragments.length > 0
          fragments = $.map fragments, (frag, i) ->
            classes = if pauses[i-1] then pauses[i-1].className.replace(/\bm-pause\b/, '') else ''
            "<span class='m-pause-parsed #{classes}'>#{frag}</span>"
          elBreak.html(fragments.join(''))

      # Collect all actors & store them for the play, then trigger an event
      actors = jqEl.find('.m-break-parsed, span.m-pause-parsed')
      jqEl.data('magicio', {actors: actors})
      jqEl.trigger($.Event('afterparse', {actors: actors}))

    run: () ->
      @each () ->
        log "Magicio found on element: %o", $(@).data('magicio')

  $.fn.extend
    magicio: (method) ->
      if methods[method]
        methods[method].apply(@, Array.prototype.slice.call(arguments, 1))
      else
        methods.init.apply(@, arguments)

)(jQuery)
