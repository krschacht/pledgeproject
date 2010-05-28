// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready( function() {

  $('.has_countdown').each( function() {
    $(this).countdown( {
      until: new Date( $(this).attr( 'until' ) ),
      compact: true,
      timezone: -6,
      format: 'dHMS',
      description: ''
    } );
  } );

} );