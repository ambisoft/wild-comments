var WILD_COMMENTS = WILD_COMMENTS || {};

WILD_COMMENTS.render_commenters_table = function(results) {
  
  var table = $('<table/>').addClass('table table-striped');
  var thead = $('<thead/>');
  var thead_tr = $('<tr/>');
  thead_tr.append($('<th/>').html('Name'));
  thead_tr.append($('<th/>').addClass('comments').html('Comments'));
  
  var tbody = $('<tbody/>');
  if (results.talkers.length) {
      $(results.talkers).each(function() {
        var tr = $('<tr/>');
        tr.append($('<td/>').html(this.name));
        tr.append($('<td/>').html(this.count));
        tbody.append(tr);
      });
  } else {
      var tr = $('<tr/>');
      tr.append($('<td/>').attr('colspan', 2).html('No data available'));
      tbody.append(tr);
  }
  table.append(thead).append(tbody);
  
  $('.talkers-info').html(table);
  
};

WILD_COMMENTS.pull_entries = function(url) {  
  $.ajax(url, {
    cache: false,
    dataType: 'html',
    success: function(result) {
      $('.feed-wrapper').empty().append(result);      
    }
  });
};

WILD_COMMENTS.pull_talkers = function(url) {
  
  function buildError(txt) {
      var icon = $('<i/>').addClass('icon-warning-sign');
      var error = $('<div/>').addClass('alert alert-error');
      error.append(icon).append(txt);        
      return error;
  }
  
  function renderError(txt) {
      $('.talkers-info').html(buildError(txt));
  }
  
  $.ajax(url, {
    cache: false,
    dataType: 'json',
    error : function(jqXHR, textStatus, errorThrown) {        
      var msg = 'Request could not be completed';      
      renderError(msg);
    },
    success: function(result) {      
      if (result && (('' + result.status) == '0')) {
        WILD_COMMENTS.render_commenters_table(result);
      } else {          
        var msg = 'Unexpected error occured (' + result.status + ')';
        renderError(msg);        
      }      
    }
  });
};

