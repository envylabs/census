jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
	update_positions();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
	$('.census_question_list').sortable('refresh');
	$('.census_choice_list').sortable('refresh');
	
	if (association == "questions") {
		$('.census_choice_list').sortable({items:'.census_choice', containment:'parent', axis:'y', update: function() {
			update_positions();
		}});
	}
	
	update_positions();
}

function update_positions() {
	$('.census_question').each(function(index) {
		$(this).find('.question_position').val(index + 1);
	  $(this).find('.census_choice').each(function(index) {
			$(this).find('.choice_position').val(index + 1);
		});
	});
}

$(function() {
	$('.census_data_group_list').sortable({items:'.census_data_group', containment:'parent', axis:'y', update: function() {
	  $.post('/census/data_groups/sort', '_method=put&'+$(this).sortable('serialize'));
	}});	
	$('.census_question_list').sortable({items:'.census_question', containment:'parent', axis:'y', update: function() {
		update_positions();
	}});	
	$('.census_choice_list').sortable({items:'.census_choice', containment:'parent', axis:'y', update: function() {
		update_positions();
	}});
	update_positions();
})
