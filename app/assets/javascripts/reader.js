(function($){

  var eventer = {};

  var contentHelper = {
    getEl: function() { return $("#content"); },
  };

  var collapseHelper = {
    getEls: function() {
      return $(".collapse");
    }
  };

  var viewFilter = {
    getTabEl: function() { return $("#items-nav"); },
    clicked: function(ev) {
      var el = $(ev.target);
      if (!el.hasClass("item-viewed-filter")) {
        return;
      }
      var parts = el.attr("href").split("-");
      var url = "/items/feed/" + parts[1] + "?item_viewed_filter=" + parts[2];
      feedHelper.fetch(url);
    },
    init: function() {
      $(contentHelper.getEl()).click($.proxy(this.clicked, this));
    }
  };

  var navHelper = {
    getPane: function() { return $("#nav"); },
    removeHighlight: function() {
      $("#nav li").removeClass("active");
    },
    highlight: function(el) {
      el.parents("li").first().addClass("active");
    },
    clicked: function(ev) {
      this.removeHighlight();
      var linkEl = $(ev.target)
        , url = linkEl.attr("href");

      if (!linkEl.hasClass("feed-url")) {
        return;
      }

      ev.preventDefault();

      this.highlight(linkEl);
      feedHelper.fetch(url);
    },
    init: function() {
      this.getPane().click($.proxy(this.clicked, this));
    }
  }

  var feedHelper = {
    fetched: function(data) {
      try {
        var feed = data.feed
          , items = data.items
          , item_viewed_filter = data.item_viewed_filter;

        contentHelper.getEl().html(items);
        collapseHelper.getEls().collapse();
        $(eventer).trigger("feedHelper.loaded", [feed, item_viewed_filter]);
      } catch (e) {}
    },
    fetch: function(url) {
      $.get(url, $.proxy(this.fetched, this));
    }
  };

  var itemViewed = {
    result: function(item) {
      var headerEl = $("#item-header-"+ item.id);
      var parentEl = headerEl.parent("div");
      parentEl.addClass("item-viewed");
      $(eventer).trigger("itemViewed.viewed", [item]);
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
      if (!el.hasClass("item-title")) {
        return;
      }
      try {
        var itemId = el.attr("href").split("-")[1];
        var toggleEl = $("#collapse-" + itemId);
        if (this.open) {
          $("#collapse-"+ this.open).collapse("toggle");
        }
        this.open = itemId;

        itemViewed.viewed(itemId);
        itemLoader.load(itemId);
      } catch (e) {}
    },
    init:function() {
      contentHelper.getEl().click($.proxy(this.contentClicked, this));
    }
  };

  $(function(){
    navHelper.init();
    itemHelper.init();
    viewFilter.init();
  });

})(jQuery);

