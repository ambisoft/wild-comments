var WILD_COMMENTS = WILD_COMMENTS || {};

WILD_COMMENTS.pull_talkers = function(url) {
  $.ajax(url, {
    cache: false,
    dataType: 'json',
    success: function(result) {      
      if (result && (('' + result.status) == '0')) {
        
      } else {
        var icon = $('<i/>').addClass('icon-warning-sign');
        var error = $('<div/>').addClass('alert alert-error');
        error.append(icon).append('Unexpected error occured (' + result.status + ')');
        $('.talkers-info').html(error);
      }      
    }
  });
};

