function SlowClickGui() {
}

SlowClickGui.prototype = {

   myHasVisibleData : false,
   myHasData        : false,
   myHasFilter      : false,

   set hasVisibleData(flag) {
      if (flag != this.myHasVisibleData) {
         this.myHasVisibleData = flag;
         this.enableDataCommands(flag);
      }
   },

   set hasData(flag) {
      if (flag != this.myHasData) {
         this.myHasData = flag;
         this.enableClearCommand(flag);
      }
   },

   set hasFilter(flag) {
      if (flag != this.myHasFilter) {
         this.myHasFilter = flag;
         this.enableFilterCommands(flag);
      }
   },

   addRequestData : function(item) {
      if (item.requestHeaders != null) {
         // add request row here?
         for(var header in item.requestHeaders) {
            this.addRequestRow(header, item.requestHeaders[header]);
         }
         if (item.getPostData() != null) {
            for(header in item.postBodyHeaders) {
               this.addRequestRow(header, item.postBodyHeaders[header]);
            }
            if (!item.isPostDataBinary()) {
               this.addRequestRow("POSTDATA", item.getPostData());
            } else {
               // evil hack to prevent details dialog from parsing values
               // there should be a better way...
               this.addRequestRow("POSTDATA" + " ", item.getPostData());
            }
         }
      }
   },

   addRequestRow : function(name, value) {
      this.addDetailRow(this.requestList, name, value);
   },

   addDetailRow : function(parent, name, value) {
      var item = document.createElement('listitem');
      item.setAttribute("slowclicks.name", name);
      item.setAttribute("slowclicks.value", value);
      item.appendChild(this.createCell(name));
      item.appendChild(this.createCell(value));
      item.setAttribute("tooltipText", value);
      parent.appendChild(item);
   },

   createCell : function(text) {
      var cell = document.createElement("listcell");
      cell.setAttribute("label", text);
      return cell;
   },

   addResponseData : function(item) {
      if (item.responseHeaders != null) {
         this.addResponseRow("Status", item.statusText + " - " + item.status);
         for(var header in item.responseHeaders ) {
            this.addResponseRow(header, item.responseHeaders [header]);
         }
      }
   },

   addResponseRow : function(name, value) {
      this.addDetailRow(this.responseList, name, value);
   },

   // For Starting and stopping the slow click analysis
   toggleTampering : function(value) {
      var startCommand = document.getElementById('slowclicks.start');
      var stopCommand = document.getElementById('slowclicks.stop');
      if (value) {
         startCommand.setAttribute("disabled", "true");
         stopCommand.removeAttribute("disabled");
      } else {
         startCommand.removeAttribute("disabled");
         stopCommand.setAttribute("disabled", "true");
      }
   },
  
   
   clear : function(tamper) {
      // the data has been emptied, tell the tree
      this.tree.data = tamper;
      this.enableClearCommand(false);
   }, 

   currentFilter : null,

   filterData : function() {
      this.currentFilter = this.filter;
      this.tree.filter(this.currentFilter);
      if (this.currentFilter != null && this.currentFilter != "") {
         this.hasFilter = true;
      } else {
         this.hasFilter = false;
      }
   },

   get filter() {
      return this.filterInput.value;
   },

   clearFilter : function() {
      this.filterInput.value = null;
      this.filterData();
   },

   showGraph : function(all) {
      // extract the xml
      var graphTitle = "Requests Graph";
      var graph = new SlowClickGraph(graphTitle, this.tree.getXML(all));
      var graphText = graph.getHTML();

      var win = window.open("data:text/html;charset=utf-8," + graphText, "Request Graph", "menubar=yes,resizable=yes,scrollbars=yes,status=no,dependent=yes,width=750,height=500");
      // win.document.write causes a security violation
   },

   exportXML : function() {
      TamperUtils.writeFile(this.langString("select.file"), this.tree.getXML(false));
   },

   exportAllXML : function() {
      TamperUtils.writeFile(this.langString("select.file"), this.tree.getXML(true));
   }
};
