var element,form,layer;
layui.use(['element','form','layer'], function(){
	element = layui.element;
	form = layui.form;
	layer = layui.layer;
	form.on('submit(*)', function(data){
		var index = layer.load(1);
		$.post(data.form.action, data.field, function(d) {
			if(d.code == 1){
				layer.msg(d.msg,{icon:1});
				setTimeout(function(){
					window.location.href = d.url;
				},1500);
			}else{
				layer.msg(d.msg,{icon:2});
				if(d.msg == 'Incorrect verification code'){
					reloadCodes();
				}
			}
			layer.close(index);
		},"json");
		return false;
	});
	//Search
    $('.searchbut').on('click', function() {
	    var key = $('#key').val();
	    if(key == ''){
	    	layer.msg('Please enter the keywords to search',{icon:2});
	    	return false;
	    }else{
	    	var link = $(this).attr('link');
	    	window.location.href = link+'?key='+key;
	    }
    });


	form.on('submit(del_pl)', function(data){
		if(JSON.stringify(data.field).length<3){
			layer.msg('No data selected for deletion...',{icon:7});return;
		}
		layer.confirm('Are you sure you want to delete this data?', {
			title:'Delete prompt',
		    btn: ['Ok', 'Cancel'], //Button
		    shade:0.001
		}, function(index) {
		    var index = layer.load(1);
			$.post(data.form.action, data.field, function(data) {
				if(data.code == 1){
					layer.msg('Congratulations, the operation is successful!',{icon:1});
					setTimeout(function(){
						if(typeof(data.parent) != undefined && data.parent == 1){
							parent.location.href = data.url;
						}else{
							location.href = data.url;
						}
					},1500);
				}else{
					layer.msg(data.msg,{icon:2});
				}
				layer.close(index);
			},"json");
			return false;
		}, function(index) {
		    layer.close(index);
		});
	});


});
function del_one(url,id){
	if(arguments[2]){
		var title = arguments[2];
	}else{
		var title = 'Are you sure you want to delete the column data?';
	}
	if(!id){
		layer.msg('Error, please refresh and try again',{icon:2});
	}else{
		layer.confirm(title, {
			title:'Delete prompt',
		    btn: ['Ok', 'Cancel'], //Button
		    shade:0.001
		}, function(index) {
		    $.post(url, {
				id:id
			}, function(data) {
				if(data.error == 0){
					layer.msg('Successfully deleted',{icon:1});
					$('#row_'+id).remove();
					if(typeof(data.info.turn) != undefined && data.info.turn ==1){
						setTimeout(function(){
							location.href = data.info.url;
						},1500);
					}
				}else{
					layer.msg(data.info,{icon:2});
				}
			},"json");
		}, function(index) {
		    layer.close(index);
		});
	}
}
function get_open(url,title,w,h){
	layer.open({
		title:title,
		type: 2,
		area: [w, h],
		closeBtn: 1, //Don't show close button
		shade: 0.01,
		shadeClose: true, //Open Mask Close
		content: url
	});
}
function reloadCodes(){
    $('.verifyimg').attr('src', "/index.php/code?" + Math.random());
}
function getajax(url,ac){
	if(ac == 'del'){
		layer.confirm('Are you sure you want to delete videos?', {
			title:'Reminder',
		    btn: ['Ok', 'Cancel'], //Button
		    shade:0.001
		}, function(index) {
		    $.get(url, function(data) {
				if(data.code == 1){
					layer.msg(data.msg,{icon:1});
					setTimeout(function(){
						location.reload();
					},1500);
				}else{
					layer.msg(data.msg,{icon:2});
				}
			},"json");
		}, function(index) {
		    layer.close(index);
		});
	}else{
	    $.get(url, function(data) {
			if(data.code == 1){
				layer.msg(data.msg,{icon:1});
			}else{
				layer.msg(data.msg,{icon:2});
			}
		},"json");
	}
}

function select_all(){
	var a = $(".xuan");  
    for(var i = 0; i < a.length; i++) {
        a[i].checked = (a[i].checked) ? false : true;
    }
}