function show(id,button){
  document.getElementById(id).style.visibility="visible";
  document.getElementById(id).style.display="block";
  document.getElementById(button).style.visibility="hidden";
  document.getElementById(button).style.display="none";
}
 
function hide(id,button){
  document.getElementById(id).style.visibility="hidden";
  document.getElementById(id).style.display="none";
  document.getElementById(button).style.visibility="visible";
  document.getElementById(button).style.display="block";
}

function connectFacebook(IdClient,APP_ID){
  protocol = location.protocol;
  hostname = location.host;
  start_date = document.getElementById('facebook_datum_start_date').value;
  end_date = document.getElementById('facebook_datum_end_date').value;
  var redirect_path = protocol+"//"+hostname+"/facebook_data/callback/"+IdClient+"/"+start_date+"/"+end_date+"/?";
  var path = 'https://www.facebook.com/dialog/oauth?';
  var queryParams = ['client_id=' + APP_ID,
    'redirect_uri='+redirect_path,
    'response_type=code'];
  var query = queryParams.join('&');
  var url = path + query;
  window.location.href = url;
}


function saveComment(form,social_network,id_comment){
  jQuery.ajax( {
    type: 'POST',
    url: '/facebook_data/save_comment',
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

function updateImageComment(form, id_image){
  jQuery.ajax({
    type: 'POST',
    url: '/facebook_data/update_comment',
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

function createChart(container,title,series,dates){
  jQuery(function () {
    var chart;
    $(document).ready(function() {
      chart = new Highcharts.Chart({
        chart: { renderTo: "'" + container + "'", type: 'line', marginRight: 130, marginBottom: 45 },
        title: { text: title, x:-20 },
        xAxis: { categories: [ dates ] },
        yAxis: { title: { text: 'Datos' }, plotLines: [{ value: 0, width: 1, color: '#808080' }] },
        tooltip: { formatter: function () { return '<b>' + this.series.name + '</b><br/>' + this.x + ': ' + this.y; }},
        leyend: {layout: 'vertical', align: 'right', verticalAlign: 'top', x: -10, y:100, borderWidth: 0},
        series: [ series ]
        });
      });
    });
    alert(container);
}
