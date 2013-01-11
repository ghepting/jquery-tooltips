#####################################
#
#  jQuery Tooltips by Gary Hepting
#
#####################################

(($) ->
  $.fn.tooltip = (options) ->
    defaults =
      topOffset: 0

    options = $.extend(defaults, options)

    tooltip = $('#tooltip')         # tooltip element
    delayShow = ''                  # delayed open
    trigger = ''                    # store trigger
    
    getElementPosition = (el) ->    # get element position
      offset = el.offset()
      win = $(window)
      top: top = offset.top - win.scrollTop()
      left: left = offset.left - win.scrollLeft()
      bottom: bottom = win.height() - top - el.outerHeight()
      right: right = win.width() - left - el.outerWidth()

    closetooltip = ->
      tooltip.remove()              # remove tooltip

    setPosition = (trigger) ->
      # get trigger element coordinates
      coords = getElementPosition(trigger)
      # tooltip dimensions
      if tooltip.outerWidth() > ($(window).width() - 20)
        tooltip.css('width',$(window).width() - 20)
      width = tooltip.outerWidth()
      height = tooltip.outerHeight()
      # horizontal positioning
      attrs = {}
      if (width+coords.left) < $(window).width() # left aligned tooltip (default)
        tooltip.addClass('left')
        attrs.left = coords.left
      else # right aligned tooltip
        tooltip.addClass('right')
        attrs.right = coords.right
        # adjust max width
        tooltip.css('max-width', 
          Math.min(
            (coords.left+trigger.outerWidth()-10),
            parseInt(tooltip.css('max-width'))
          )
        )
        # recalculate dimensions
        width = tooltip.outerWidth()
        height = tooltip.outerHeight()
      # veritcal positioning
      if (coords.top-options.topOffset) > (height+20) # top positioned tooltip
        tooltip.addClass('top')
        attrs.top = (trigger.offset().top - height) - 20
      else # bottom positioned tooltip
        tooltip.addClass('bottom')
        attrs.top = trigger.offset().top + 15
      tooltip.css attrs

    showtooltip = (e) ->
      closetooltip()                  # close tooltip
      clearTimeout(delayShow)         # cancel previous timeout
      delayShow = setTimeout ->
        trigger = $(e.target)         # set trigger element
        # create tooltip DOM element
        tooltip = $("<div id=\"tooltip\"></div>")
        # add tooltip element to DOM
        tooltip.css("opacity", 0).html(trigger.attr('data-title')).appendTo "body"
        # initialize tooltip
        setPosition(trigger)
        tooltip.animate
          top: "+=10"
          opacity: 1
        , 100
      , 100

    @each ->
      $this = $(this)

      $this.attr('role','tooltip').attr('data-title',$this.attr('title'))
      $this.removeAttr "title"        # remove title attribute
        
      # hover on trigger element
      $this.bind
        mouseenter: (e) ->
          showtooltip(e)                    # show tooltip
        mouseleave: ->
          clearTimeout(delayShow)           # cancel delay show
          closetooltip()                    # close tooltip

) jQuery