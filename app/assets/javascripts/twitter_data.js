function saveCommentTwitter(form,social_network,id_comment,locale){
  jQuery.ajax( {
    type: 'POST',
    url: locale+'/twitter_data/save_comment',
    data: { comment: $(form).find("#comment").val(), social_network: social_network, id_comment: id_comment },
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
