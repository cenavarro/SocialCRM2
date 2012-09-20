function updateImageComment(form, id_image,locale){
  jQuery.ajax({
    type: 'POST',
    url: '/'+locale+'/social_networks/update_comment',
    data: { comment: $(form).find("#comment").val(), id_image: id_image },
    dataType: 'json',
    success: function(data){
      $(form).find('.result').html(data);
    },
    error: function(data){
      $(form).find('.result').html(data);
    }
  });
  return false;
}
