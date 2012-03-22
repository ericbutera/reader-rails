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

  var tabHelper = {
    loaded: function(ev, feed, item_viewed_filter) {
      console.log("tab helper saw nav loaded %o %o %o", ev, feed, item_viewed_filter);
    },
    init: function() {
      $(eventer).bind("feedHelper.loaded", $.proxy(this.loaded, this));
    }
  };

  var feedHelper = {
    // todo refactor this into feedHelper & navHelper
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
          try {
            var feed = data.feed
              , items = data.items
              , item_viewed_filter = data.item_viewed_filter;

            contentHelper.getEl().html(items);
            collapseHelper.getEls().collapse();
            $(eventer).trigger("feedHelper.loaded", [feed, item_viewed_filter]);
          } catch (e) {}
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

  var itemLoader = {
    getEl: function(id) {
      return $("#item-content-"+ id);
    },
    load: function(id) {
      $.get("/items/sanitized/"+ id, function(data){
        itemLoader.getEl(id).html(data);
      });
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
          itemLoader.load(itemId);
        } catch (e) {}
      }
    },
    init:function() {
      contentHelper.getEl().click($.proxy(this.contentClicked, this));
    }
  };

  $(function(){
    contentHelper.init();
    feedHelper.init();
    itemHelper.init();
    tabHelper.init();
  });

})(jQuery);

