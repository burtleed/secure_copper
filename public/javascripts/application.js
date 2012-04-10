// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
  /*$("#message_recepient_tokens").tokenInput("/users/search.json", {
    crossDomain: false,
    prePopulate: $("#message_recepient_tokens").data("pre"),
    noResultsText:     "No results, needs to be created.",
    theme: "facebook"
  });*/
});

$(document).ready(function() {

  $("body").delegate('#save_form',"click", function(){
  	 if($('#admin_group_add_users_ids').length > 0){
		$('#admin_group_add_users_ids').val($('#gp_mem').data('MoverBoxes').SelectedValues());
  	 }
    $("#save_method").val("apply");
    $('input[type=submit]').closest("form").find(':checkbox').attr('disabled', false);
    $('#save_method').closest('form').submit();
  });  

  $("body").delegate('#save_new',"click", function(){
  	 if($('#admin_group_add_users_ids').length > 0){
		$('#admin_group_add_users_ids').val($('#gp_mem').data('MoverBoxes').SelectedValues());
  	 }
    $("#save_method").val("apply_new");
    $('input[type=submit]').closest("form").find(':checkbox').attr('disabled', false);
    $('#save_method').closest('form').submit();
  });

  $("body").delegate('#edit_form',"click", function(){
    if($("input[@type=checkbox][checked]").size() > 0){
      $("#source").val("edit");
      $('#edit_form').closest('form').submit();
    }
    else{
      alert("Please select row you want to make changes.");
    }
  });

  $("body").delegate('#delete_form',"click", function(){
    if($("input[@type=checkbox][checked]").size() > 0){
      if(!confirm("Are you sure?")) return false;
      $("#source").val("delete");
      $('#edit_form').closest('form').submit();
    }
    else{
      alert("Please select rows to delete records.");
    }
  });
  
  $("body").delegate('.topactivate',"click", function(){
    if($("input[@type=checkbox][checked]").size() > 0){
    	if(!confirm("Are you sure?")) return false;
    	$("#source").val("activate");
      $('#edit_form').closest('form').submit();
    }
    else{
      alert("Please select rows to activate records.");
    }
  });
  
  $("body").delegate('.topblock',"click", function(){
    if($("input[@type=checkbox][checked]").size() > 0){
      if(!confirm("Are you sure?")) return false;
    	$("#source").val("block");
		$('#edit_form').closest('form').submit();		      
    }
    else{
      alert("Please select rows to block records.");
    }
  });

  $("body").delegate('#checkall-toggle',"click", function(){
    $(this).parents('table').find(':checkbox').attr('checked', this.checked);
  });

  $("body").delegate('#search',"click", function(){
    if($("#filter_search").val() == ''){
      alert("Please enter search term");
      return false;
    }
    $("#source").val("go");
    $('#search').closest('form').submit();
  });

  $("body").delegate('#clear',"click", function(){
    $("#filter_search").val("");
    $("#source").val("reset");
    $('#clear').closest('form').submit();
  });

  $("#setting_form").fancybox();
});
