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

function saveChartComment(form,social_network,id_comment,locale, id_name){
  jQuery.ajax( {
    type: 'POST',
    url: '/'+locale+'/'+id_name+'_data/save_comment',
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

$(document).ready(function(){
  var chart = null;
  createChart = function(container, title, categorie){
    chart = new Highcharts.Chart({
      chart : { renderTo : container, type : 'line', marginRight : 130, marginBottom : 45, width : 806 },
      title : { text : title, x: -20 },
      xAxis : {
        categories : categorie,
      },
      yAxis : {
        title : { text : '' },
        plotLines : [ { value : 0, width : 1, color : '#808080' }] },
      tooltip : {
        formatter : function() {
          return '<b>'+ this.series.name +'</b><br/>'+
          this.x +': '+ this.y; } },
      legend : { layout : 'vertical', align : 'right', verticalAlign : 'top', x : -10, y : 100, borderWidth : 0 },
      navigator : { enabled : false},
      series : [ ],
      scrollbar : { enabled : true }
    });
    var maxSeries;
  },

  addSerie = function(serie){
    chart.addSeries(serie);
    if(serie.data.length > 6){
      maxSeries = 6;
    }else{
      maxSeries = serie.data.length;
    }
  },

  refreshChart = function(xMax){
    chart.setSize(806, 400, false);
    if (xMax != null){
      maxSeries = xMax;
    }
    chart.xAxis[0].setExtremes(0, (maxSeries - 1), true, false);
  }

  $("#start_date_picker").datepicker({ format: 'dd-mm-yyyy' });
  $("#end_date_picker").datepicker({ format: 'dd-mm-yyyy' });
  var startDate = new Date(2012,0,01);
  var endDate = new Date(2012,0,01);
  $("#start_date_picker").datepicker()
    .on('changeDate', function(ev){
      $("#start_date_picker").datepicker('hide');
    });
  $("#end_date_picker").datepicker()
    .on('changeDate', function(ev){
      $("#end_date_picker").datepicker('hide');
    });
});

function createChart(container, title, categories){
  $(function(){
    createChart(container, title, categories)
  })
}

function addSerie(n, d){
  var serie = { name: n, data: d };
  $(function(){
    addSerie(serie)
  })
}

function refreshChart(xAxisMax){
  $(function(){
    xAxisM = typeof xAxisMax !== 'undefined' ? xAxisMax : null; 
    refreshChart(xAxisM)
  })
}
