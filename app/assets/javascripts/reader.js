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

  var collapseHelper = {
    getEls: function() {
      return $(".collapse");
    }
  };

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
          collapseHelper.getEls().collapse();
        });
      }
    },
    init: function() {
      this.getPane().click($.proxy(this.clicked, this));
    }
  };

  var itemViewed = {
    result: function(item) {
      // $(eventer).trigger("itemViewed.viewed", [item]);
      var headerEl = $("#item-header-"+ item.id);
      var parentEl = headerEl.parent("div");
      parentEl.addClass("item-viewed");
    },
    viewed: function(itemId) {
      $.post("/items/viewed/"+ itemId, $.proxy(this.result, this));
    }
  };

  var itemHelper = {
    open: false,
    handleShow: function(ev) {
      console.log("itemHelper.handleShow %o", ev);
    },
    closeAll: function() {
      collapseHelper.getEls().collapse("hide");
    },
    contentClicked: function(ev) {
      var el = $(ev.target);
      if (el.hasClass("item-title")) {
        try {
          var itemId = el.attr("href").split("-")[1];
          var toggleEl = $("#collapse-" + itemId);
          if (this.open) {
            /*if (this.open == itemId) { 
              console.log("toggling");
              // TODO for some reason, this messes with the padding
              //$("#collapse-"+ this.open).collapse({toggle:true});
              $("#collapse-"+ this.open).collapse("toggle");
            } else {
              console.log("closing old id %o %o", itemId, this.open);
              $("#collapse-"+ this.open).collapse("toggle");
            }*/
            $("#collapse-"+ this.open).collapse("toggle");
          }
          this.open = itemId;

          itemViewed.viewed(itemId);
        } catch (e) {}
      }
    },
    init:function() {
      contentHelper.getEl().click($.proxy(this.contentClicked, this));
    }
  };

  $(function(){
    contentHelper.init();
    navHelper.init();
    itemHelper.init();
  });

})(jQuery);

