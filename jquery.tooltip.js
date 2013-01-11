/************************************
 *
 *  jQuery Tooltips by Gary Hepting
 *
 ************************************/

(function($) {
  return $.fn.tooltip = function(options) {
    var closetooltip, defaults, delayShow, getElementPosition, setPosition, showtooltip, tooltip, trigger;
    defaults = {
      topOffset: 0
    };
    options = $.extend(defaults, options);
    tooltip = $('#tooltip');
    delayShow = '';
    trigger = '';
    getElementPosition = function(el) {
      var bottom, left, offset, right, top, win;
      offset = el.offset();
      win = $(window);
      return {
        top: top = offset.top - win.scrollTop(),
        left: left = offset.left - win.scrollLeft(),
        bottom: bottom = win.height() - top - el.outerHeight(),
        right: right = win.width() - left - el.outerWidth()
      };
    };
    closetooltip = function() {
      return tooltip.remove();
    };
    setPosition = function(trigger) {
      var attrs, coords, height, width;
      coords = getElementPosition(trigger);
      if (tooltip.outerWidth() > ($(window).width() - 20)) {
        tooltip.css('width', $(window).width() - 20);
      }
      width = tooltip.outerWidth();
      height = tooltip.outerHeight();
      attrs = {};
      if ((width + coords.left) < $(window).width()) {
        tooltip.addClass('left');
        attrs.left = coords.left;
      } else {
        tooltip.addClass('right');
        attrs.right = coords.right;
        tooltip.css('max-width', (coords.left + trigger.outerWidth()) - 10);
        width = tooltip.outerWidth();
        height = tooltip.outerHeight();
      }
      if ((coords.top - options.topOffset) > (height + 20)) {
        tooltip.addClass('top');
        attrs.top = (trigger.offset().top - height) - 20;
      } else {
        tooltip.addClass('bottom');
        attrs.top = trigger.offset().top + 15;
      }
      return tooltip.css(attrs);
    };
    showtooltip = function(e) {
      closetooltip();
      clearTimeout(delayShow);
      return delayShow = setTimeout(function() {
        trigger = $(e.target);
        tooltip = $("<div id=\"tooltip\"></div>");
        tooltip.css("opacity", 0).html(trigger.attr('data-title')).appendTo("body");
        setPosition(trigger);
        return tooltip.animate({
          top: "+=10",
          opacity: 1
        }, 100);
      }, 100);
    };
    return this.each(function() {
      var $this;
      $this = $(this);
      $this.attr('role', 'tooltip').attr('data-title', $this.attr('title'));
      $this.removeAttr("title");
      return $this.bind({
        mouseenter: function(e) {
          return showtooltip(e);
        },
        mouseleave: function() {
          clearTimeout(delayShow);
          return closetooltip();
        }
      });
    });
  };
})(jQuery);