function zoneContainer() {
  return $('#zone');
}
function recordsContainer() {
  return $('#records');
}
var zone = null;

function closeModal( el ) {
  el.fadeOut( 'fast', function() {
    $('#overlay').fadeOut( 'fast' );
  } );
}
function openModal( el ) {
  $('#overlay').fadeIn( 'fast', function() {
    el.fadeIn( 'fast' );
  } );
}

$(document).ready( function() {
  var pathPrefix = $('meta[name=path_prefix]').attr('content');

  // modal handlers
  $('.modal .modal-header a.close, .modal .modal-footer .btn.secondary').live( 'click', function() {
    closeModal( $('#new_zone_modal') );
  } );

  $('#zone_select').change( function() {
    var select = $(this);
    zone = select.val();
    if( zone == 'none' ) {
      // unload the current zone
      zoneContainer().html('');
      return;
    }
    else if( zone == 'new' ) {
      // show a modal to create a new zone
      openModal( $('#new_zone_modal') );
      select.val(zone || 'none');
    }
    else {
      // load the selected zone
      $.ajax( {
        url: pathPrefix + '/zone/' + zone,
        dataType: 'json',
        type: 'GET',
        success: function( r ) {
          if( r.ok ) {
            zoneContainer().html( r.zone );
          }
        }
      } );
    }
  } );

  $('#record_type_select li').live( 'click', function() {
    var tab = $(this);
    var record_type = tab.attr('rel');
    tab.addClass('active').siblings().removeClass('active');
    $.ajax( {
      url: pathPrefix + '/zone/' + zone + '/records/' + record_type.replace('/', '|'),
      dataType: 'json',
      type: 'GET',
      success: function( r ) {
        if( r.ok ) {
          recordsContainer().html( r.records );
        }
      }
    } );
    return false;
  } );
} );
