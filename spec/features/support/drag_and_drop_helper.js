(function( $ ) {
  $.fn.simulateDragDrop = function(options) {
    return this.each(function() {
      new $.simulateDragDrop(this, options);
    });
  };
  $.simulateDragDrop = function(elem, options) {
    this.options = options;
    this.simulateEvent(elem, options);
  };
  $.extend($.simulateDragDrop.prototype, {
    simulateEvent: function(elem, options) {
      /*Simulating drag start*/
      $(elem).trigger('dropstart');

      /*Simulating drop*/
      $(elem).detach().insertAfter($(options.dropTarget))
      $(elem).trigger('drop');

      /*Simulating drag end*/
      $(elem).trigger('dragend');
    }
  });
})(jQuery);
