(function($){

  var eventer = {};

  var contentHelper = {
    getEl: function() {
      return $("#content");
    },
    init: function() {
    }
  };

/*
- nav links need to be able to refresh when a new feed is added
- feed unread counts
-
*/
  var navHelper = {
    getPane: function() { return $("#nav"); },
    removeHighlight: function() {
      $("#nav li").removeClass("active");
    },
    clicked: function(ev) {
      this.removeHighlight();

      var linkEl = $(ev.target);
      if (linkEl.hasClass("feed-url")) {
        ev.preventDefault();
        var url = linkEl.attr("href");
        linkEl.parents("li").first().addClass("active");
        $.get(url, function(data) {
          contentHelper.getEl().html(data);

          $(".collapse").collapse();
          //var first = $(".collapse").first().collapse("show");
        });
      }
    },
    init: function() {
      this.getPane().click($.proxy(this.clicked, this));
    }
  };


  $(function(){
    contentHelper.init();
    navHelper.init();
  });

})(jQuery);
