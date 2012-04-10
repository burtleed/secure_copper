$(document).ready(function(){
  //$(".div_contact_list_no_border").click(message_list);
  $('.ct_contacts li').click(message_list);
    
  $("#select_user").fancybox({
			'width'				: '75%',
			'height'			   : '75%',
			'autoScale'			: false,
			'transitionIn'		: 'none',
			'transitionOut'	: 'none',
			});
			
 $('#first_name').bindWithDelay('keyup',function(){
  $(this).closest("form").submit();
 },400);
 
 $(".ct_contacts").simplyScroll({
	className: 'vert',
	horizontal: false,
	frameRate: 20,
	speed: 5
 });

 var auto_refresh = setInterval(function(){
		refresh_chat_page()	
	},20000);
});

  function message_list(){
		var contact_id = $(this).find('input[type=hidden]:first').val();
	 	$('.ct_contacts li[class=activechat]').attr('class','');
	 	$(this).attr('class','activechat');
	 	load_messages(contact_id);      
  }

  function load_messages(contact_id){
		$('#fancybox-loading').show()
    $.ajax({
      url: '/admin/messages/list',
      async: false,
      data: "id="+contact_id, 
      dataType: 'html',
      success: function(data){
        //document.getElementById('messages_per_user').innerHTML = data;
        $('#fancybox-loading').hide();
        $("#message_recepient_id").val(contact_id);
        $("#message_submit").attr("disabled",false);
        $('.chat_notstarted').hide();
        if($('.chat_started').length > 0 ){
        		$('.chat_started').remove();
        }
        $('#print_link a').attr('href','/admin/messages/list.pdf?id='+contact_id);
        $('#print_link').show();
        $('.chatright').prepend(data);
        $('.chat_initiate').scrollTop($('.chat_initiate')[0].scrollHeight);
      }
   	});  	
  }
  
  function refresh_chat_page(){
  	if($('.activechat').length > 0 ){
			contact_id = $('.activechat').find('input').val();
			load_messages(contact_id); 
		}							
  }