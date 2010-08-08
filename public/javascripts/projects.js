$(document).ready( function() {

  if( $('body').hasClass('projects') ) {

  }

} );

function show_close_msg_dialog( id ) {
  $('#' + id + '_link').addClass('hidden');
  $('#' + id + '_dialog').removeClass('hidden');
}

function hide_close_msg_dialog( id ) {
  $('#' + id + '_link').removeClass('hidden');
  $('#' + id + '_dialog').addClass('hidden');
}

                          