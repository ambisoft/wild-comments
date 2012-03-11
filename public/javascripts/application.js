var WILD_COMMENTS = WILD_COMMENTS || {};

WILD_COMMENTS.render_table = function(results) {
  
  var table = $('<table/>').addClass('table table-striped');
  var thead = $('<thead/>');
  var thead_tr = $('<tr/>');
  thead_tr.append($('<th/>').html('Name'));
  thead_tr.append($('<th/>').addClass('comments').html('Comments'));
  
  var tbody = $('<tbody/>');  
  $(results.talkers).each(function() {
    var tr = $('<tr/>');
    tr.append($('<td/>').html(this.name));
    tr.append($('<td/>').html(this.count));
    tbody.append(tr);
  });  
  table.append(thead).append(tbody);
  
  $('.talkers-info').html(table);
  
};

WILD_COMMENTS.pull_talkers = function(url) {
  $.ajax(url, {
    cache: false,
    dataType: 'json',
    success: function(result) {      
      if (result && (('' + result.status) == '0')) {
        WILD_COMMENTS.render_table(result);
      } else {
        var icon = $('<i/>').addClass('icon-warning-sign');
        var error = $('<div/>').addClass('alert alert-error');
        error.append(icon).append('Unexpected error occured (' + result.status + ')');
        $('.talkers-info').html(error);
      }      
    }
  });
};

