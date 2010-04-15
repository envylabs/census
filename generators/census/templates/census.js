jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

$(function() {
	$('.census_data_group_list').sortable({items:'.census_data_group', containment:'parent', axis:'y', update: function() {
	  $.post('/census/data_groups/sort', '_method=put&'+$(this).sortable('serialize'));
	}});	
	$('.census_question_list').sortable({items:'.census_question', containment:'parent', axis:'y', update: function() {
	  $.post('/census/data_groups/' + $(this).attr("id") + '/questions/sort', '_method=put&'+$(this).sortable('serialize'));
	}});	
	$('.census_choice_list').sortable({items:'.census_choice', containment:'parent', axis:'y', update: function() {
	  $.post('/census/data_groups/' + $(this).parent('.census_question_list').attr("id") + '/questions/' + $(this).attr("id") + 'choices/sort', '_method=put&'+$(this).sortable('serialize'));
	}});	
})
