###!
* Magicio 0.2
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

  actionTypeFromEl = (el) ->
    if /\bm-break-parsed\b/.test(el.className) then 'break' else 'pause'

  inputEvent = if $?.mobile?.support?.touch then 'vclick' else 'click'

  class Action
    constructor: (@nextElement, @prevElement, @actionClasses, @actionType, @timing) ->

    eventType: () ->
      try
        @actionClasses.match(/\bm-action-(input|timeout)\b/)[1]
      catch err
        switch @actionType
          when "pause" then settings.actionOnPause
          when "break" then settings.actionOnBreak

  methods =
    init: (options) ->
      settings =
        actionOnPause: 'timeout'
        actionOnBreak: 'input'
        debug: false
        disableScrollOnSpace: false
        pauseMilliseconds: 1000

      settings = $.extend settings, options

      @each () ->
        log "Initializing Magicio for element with id \"#{@id}\""
        log "Using '#{inputEvent}' as our input event."
        jqEl = $(@)
        methods.parse(jqEl)
        methods.buildActions(jqEl)

    destroy: (jqEl) ->
      @each () ->
        log "Destroying Magicio for element with id \"#{@id}\""
        $(@).removeData('magicio')

    buildActions: (jqEl) ->
      actors = jqEl.data('magicio').actors
      jqEl.removeData('magicio', 'actors')
      actions = $.map actors, (el, i) ->
        if i > 0
          prevActionType = try
            actionTypeFromEl(actors[i-1])
          catch err
            null

          actionType = actionTypeFromEl(el)
          actionClasses = el.className.replace(/m-(pause|break)(-parsed)?/g, '')
          nextElement = el

          prevElement = if actionType is 'break'
            try
              $(el).prev('.m-break-parsed')[0]
            catch err
              null
          else
            if prevActionType is "pause"
              actors[i-1]

          timing = try
            parseInt(el.className.match(/\bm-timing-(\d+)\b/)[1], 10)
          catch err
            settings.pauseMilliseconds

          new Action(nextElement, prevElement, actionClasses, actionType, timing)

      log "Actions: %o", actions
      jqEl.data('magicio', {actions: actions})

    parse: (jqEl) ->
      jqEl.trigger('beforeparse')

      # first parse & tag explicit breaks
      breaks = jqEl.children('.m-break')
      log "Breaks: #{breaks.length}"
      if breaks.length is 0
        breaks = jqEl
      else
        breaks.addClass('m-break-parsed')

      # then parse, wrap & tag explicit pauses
      breaks.each () ->
        elBreak = $(@)
        pauses = elBreak.children('br.m-pause')
        log "Pauses: #{pauses.length}"
        pauses.replaceWith(UNIQUE_STR)
        fragments = elBreak.html().split(UNIQUE_STR)
        if fragments.length > 0
          fragments = $.map fragments, (frag, i) ->
            if /^\s+$/.test(frag)
              ''
            else
              classes = if pauses[i-1] then pauses[i-1].className.replace(/\bm-pause\b/, '') else ''
              "<span class='m-pause-parsed #{classes}'>#{frag}</span>"
          elBreak.html(fragments.join(''))

      # collect all actors & store them for the play, then trigger an event
      actors = jqEl.find('.m-break-parsed, span.m-pause-parsed')
      log "Actors: %o", actors
      jqEl.data('magicio', {actors: actors})
      jqEl.trigger($.Event('afterparse', {actors: actors}))

    run: () ->
      @each () ->
        log "Magicio running on element with data: %o", $(@).data('magicio')
        jqEl = $(@)
        elData = jqEl.data('magicio')
        actions = elData.actions
        jqEl.trigger($.Event('beforerun', {actions: actions}))
        ixCurrent = elData.current_action_index or 0
        log "Current action index pulled from data: #{ixCurrent}"
        methods.runAction(jqEl, actions, ixCurrent)

    runAction: (jqEl, actions, ix) ->
        action = actions[ix]

        # trigger after event for previous action
        prevAction = actions[ix-1]
        if prevAction
          jqEl.trigger($.Event("after#{prevAction.actionType}", {action: prevAction}))

        # if we're out of actions, wrap things up
        if not action
          log "Ran out of actions."
          jqEl.trigger($.Event("afterrun", {actions: actions}))
          return true

        # trigger before event for current action
        log "Going to execute action ##{ix} %o", action
        jqEl.trigger($.Event("before#{action.actionType}", {action: action}))

        # do whatever the action is (pause or wait for input)
        log "eventType: #{action.eventType()}"
        log "timing: #{action.timing}" if action.eventType() is "timeout"
        ixNext = ix + 1
        switch action.eventType()
          when 'timeout' then setTimeout(->
            methods.runAction(jqEl, actions, ixNext)
          , action.timing)
          when 'input'
            inputCallback = (evt) ->
              log "Firing & removing magicio document input listener."
              log "Event: %o", evt
              log "Target: %o", evt.target
              jqEl.removeData('magicio', 'input_callback')
              $(document).off "keypress #{inputEvent}", inputCallback
              if evt.which is 32 and settings.disableScrollOnSpace
                evt.preventDefault()
              if inputEvent is "vclick"
                evt.preventDefault()
                evt.stopImmediatePropagation()
              methods.runAction(jqEl, actions, ixNext)

            log "Attempting to set magicio document input listener..."
            unless (data = jqEl.data('magicio')) and data['input_callback']
              jqEl.data('magicio', {input_callback: inputCallback})
              $(document).one "keypress #{inputEvent}", inputCallback
              log "Successfully set magicio document input listener."

        # save the next index back to the collection
        jqEl.data('magicio', {current_action_index: ixNext})

  $.fn.extend
    magicio: (method) ->
      if methods[method]
        methods[method].apply(@, Array.prototype.slice.call(arguments, 1))
      else
        methods.init.apply(@, arguments)

)(jQuery)
