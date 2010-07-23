$(document).ready( function() {

  if( $('body').hasClass('groups') ) {
    if( $('#group_project_ids').length > 0 ) {
      preload_project_checkboxes();
    }
  }

} );

function preload_project_checkboxes() {
  var projects = new Array(); 
  projects = $("#group_project_ids").val().split(',');
  for(i = 0; i < projects.length; i++) {
    $('#project_' + projects[i]).attr('checked', true);
  }
  

}

function project_checkbox_clicked() {
  var projects = new Array(); 
  $("input[@name='projects[]']:checked").each(function() { projects.push($(this).val()); });    
  $("#group_project_ids").val( projects.join(',') );
}
