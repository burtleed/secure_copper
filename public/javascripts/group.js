$(document).ready(function() {
	$("#admin_group_hospital_id").change(function(event) {
		$("#admin_group_add_users_ids").val("");
		$("#admin_group_remove_users_ids").val("");
		$.ajax({
      		url: '/admin/groups/add_users',
      		data: "hospital_id="+$(this).val(),
      		dataType: 'script',
      })	
	})
});

