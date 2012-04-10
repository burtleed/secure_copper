$(document).ready(function() {
  var hospital = $("#user_hospital_id option:selected").val();

  if(hospital != ""){
    $("#user_primary_group_id").attr('readonly', false);
    $("#user_title_id").attr('readonly', false);
  }

  $("body").delegate('#user_hospital_id',"change", function(){
    hospital = $("#user_hospital_id option:selected").val();
    $('#fancybox-loading').show();
    hospital_change(hospital);
  });

  $("body").delegate('#user_primary_group_id',"change", function(){
    group_id = $("#user_primary_group_id option:selected").val();
    var checkbox_id = "#user_group_ids_"+group_id
    $(this).parents('div').find(':checkbox').attr('readonly', false);
    $(checkbox_id).attr('checked', true);
    $(checkbox_id).attr('readonly', true);
  });

  $("body").delegate('#user_group_ids_all',"click", function(){
    $(this).parents('div').find(':checkbox').attr('checked', this.checked);
    $(this).parents('div').find(':checkbox').attr('readonly', this.checked);
    $(this).attr('readonly', false);
    if(this.checked != true){
      $("#user_primary_group_id").trigger("change");
    }
  });

  $("#deny-add-list").live('click',function() {
  	  $('#fancybox-loading').show();
  		$.ajax({
      		url: '/admin/users/get-user-list/deny_add',
      		data: $(this).closest("form").serialize(),
      		success: function(data){
      			$('#fancybox-loading').hide();
					$.colorbox({html:data});
      		}
      })	
  })

   $("#allow-add-list").live('click',function() {
   	$('#fancybox-loading').show();
  		$.ajax({
      		url: '/admin/users/get-user-list/allow_add',
      		data: $(this).closest("form").serialize(),
      		success: function(data){
      			$('#fancybox-loading').hide();
					$.colorbox({html:data});
      		}
      });	
  })

  $("#allow-remove-list").live('click',function() {
  		$('#fancybox-loading').show();
  		$.ajax({
      		url: '/admin/users/get-user-list/allow_remove',
      		data: $(this).closest("form").serialize(),
      		success: function(data){
					$.colorbox({html:data});
					$('#fancybox-loading').hide();
      		}
      })	
  })

  $("#deny-remove-list").live('click',function() {
  		$('#fancybox-loading').show();
  		$.ajax({
      		url: '/admin/users/get-user-list/deny_remove',
      		data: $(this).closest("form").serialize(),
      		success: function(data){
					$('#fancybox-loading').hide();
					$.colorbox({html:data});
      		}
      })	
  })


});
function hospital_change(hospital){
  $.ajax({
    url: '/hospitalchange',
    async: false,
    data: "id="+hospital, 
    success: function(data){
    	$('#fancybox-loading').hide();
      document.getElementById('admin_only').innerHTML = data;
    }
  });
}