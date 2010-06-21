$('#note').keyup(function() {
  word_count = $(this).val().split(/[\w-]+/).length - 1;
  word_count = word_count < 0 ? 0 : word_count;
  
  $('#word_count').text( word_count );
  
  if (word_count > 200)
    $('#word_count').addClass('red');
  else
    $('#word_count').removeClass('red');
});