// Generated by CoffeeScript 1.6.2
/*!
* Magicio 0.1
*
* Copyright 2013, Brad Fults - http://bradfults.com/
* Released under the MIT License
* https://github.com/h3h/magicio/LICENSE
*
* Thanks to Dave Rupert for inspiration from Lettering.js
* https://github.com/davatron5000/Lettering.js
*/


(function() {
  var __slice = [].slice;

  (function($) {
    var Action, UNIQUE_STR, log, methods, settings;

    settings = {};
    UNIQUE_STR = "eefec303079ad17405c889e092e105b0";
    log = function() {
      var msg, others;

      msg = arguments[0], others = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (settings.debug) {
        if (others.length) {
          return typeof console !== "undefined" && console !== null ? console.log(msg, others) : void 0;
        } else {
          return typeof console !== "undefined" && console !== null ? console.log(msg) : void 0;
        }
      }
    };
    Action = (function() {
      function Action(nextElement, prevElement, breakClasses, breakType, timing) {
        this.nextElement = nextElement;
        this.prevElement = prevElement;
        this.breakClasses = breakClasses;
        this.breakType = breakType;
        this.timing = timing;
      }

      return Action;

    })();
    methods = {
      init: function(options) {
        settings = {
          debug: false,
          defaultActionOnPause: 'time'
        };
        settings = $.extend(settings, options);
        return this.each(function() {
          var jqEl;

          log("Initializing Magicio for element with id \"" + this.id + "\"");
          jqEl = $(this);
          return methods.parse(jqEl);
        });
      },
      destroy: function(jqEl) {
        return this.each(function() {
          log("Destroying Magicio for element with id \"" + this.id + "\"");
          return $(this).removeData('magicio');
        });
      },
      buildActions: function(jqEl) {
        return jqEl.data('magicio', {
          actions: actions
        });
      },
      parse: function(jqEl) {
        var actors, breaks;

        jqEl.trigger('beforeparse');
        breaks = jqEl.children('.m-break');
        log("Breaks: " + breaks.length);
        if (breaks.length === 0) {
          breaks = jqEl;
        } else {
          breaks.addClass('m-break-parsed');
        }
        breaks.each(function() {
          var elBreak, fragments, pauses;

          elBreak = $(this);
          pauses = elBreak.children('br.m-pause');
          log("Pauses: " + pauses.length);
          pauses.replaceWith(UNIQUE_STR);
          fragments = elBreak.html().split(UNIQUE_STR);
          if (fragments.length > 0) {
            fragments = $.map(fragments, function(frag, i) {
              var classes;

              classes = pauses[i - 1] ? pauses[i - 1].className.replace(/\bm-pause\b/, '') : '';
              return "<span class='m-pause-parsed " + classes + "'>" + frag + "</span>";
            });
            return elBreak.html(fragments.join(''));
          }
        });
        actors = jqEl.find('.m-break-parsed, span.m-pause-parsed');
        jqEl.data('magicio', {
          actors: actors
        });
        return jqEl.trigger($.Event('afterparse', {
          actors: actors
        }));
      },
      run: function() {
        return this.each(function() {
          return log("Magicio found on element: %o", $(this).data('magicio'));
        });
      }
    };
    return $.fn.extend({
      magicio: function(method) {
        if (methods[method]) {
          return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
        } else {
          return methods.init.apply(this, arguments);
        }
      }
    });
  })(jQuery);

}).call(this);
