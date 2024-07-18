var element,form,layer;
layui.use(['element','form','layer'], function(){
	element = layui.element;
	form = layui.form;
	layer = layui.layer;
	//Monitor website configuration/modify data form submission
	form.on('submit(setting)', function(data){
		var index = layer.load(1);
		$.post(data.form.action, data.field, function(data) {
			if(data.code == 1){
				layer.msg('Congratulations, saved successfully',{icon:1});
			}else{
				layer.msg(data.msg,{icon:2});
			}
			layer.close(index);
		},"json");
		return false;
	});
	form.on('submit(login)', function(data){
    var index = layer.load(1);
    $.post(data.form.action, data.field, function(data) {
        if(data.code == 1){
            layer.msg('<span style="color: #000000 !important;">Congratulations, you have successfully logged in!</span>', {
                icon: 1,
                time: 1500,
                // Rest of the options
            });
            setTimeout(function(){
                window.location.href = data.url;
            }, 1500);
        } else {
            layer.msg(data.msg, { icon: 2 });
        }
        layer.close(index);
    }, "json");
    return false;
});
	form.on('submit(edit)', function(data){
		var index = layer.load(1);
		$.post(data.form.action, data.field, function(data) {
			if(data.code == 1){
				layer.msg('Congratulations, the operation is successful!',{icon:1});
				setTimeout(function(){
					parent.location.reload();
				},1500);
			}else{
				layer.msg(data.msg,{icon:2});
			}
			layer.close(index);
		},"json");
		return false;
	});
	//Listen for bulk delete submissions
	form.on('submit(del_pl)', function(data){
		if(JSON.stringify(data.field).length<3){
			layer.msg('No data selected for deletion...',{icon:7});return;
		}
		layer.confirm('This will permanently remove the items and cannot be undone.', {
			title:'Delete prompt',
		    btn: ['Delete', 'Cancel'], //Button
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
//Menu click event
function turnLink(which){
	var obj = $(which);
	var link = obj.attr('_href');
	$('#iframe_main').attr('src', link);
}

function mode(m) {
	var mctime = setInterval(function(){
		if(layer !=null && layer.tips != undefined){
			eval(m);
			clearInterval(mctime);
		}
	},100);
}
function getTime(elem,type){
	elem = (elem==''||elem==undefined)?'#kstime':'#'+elem;
	type = (type==''||type==undefined)?'date':type;
	laydate.render({
		elem:elem
		,type:type
	});
}
function select_all(){
	var a = $(".xuan");  
    for(var i = 0; i < a.length; i++) {
        a[i].checked = (a[i].checked) ? false : true;
    }
}
function del_one(url,id){
	if(arguments[2]){
		var title = arguments[2];
	}else{
		var title = 'Are you sure you want to delete the column data?';
	}
	if(!id){
		layer.msg('Parameter error, please refresh and try again',{icon:2});
	}else{
		layer.confirm(title, {
			title:'Delete prompt',
		    btn: ['Delete', 'Cancel'], //Button
		    shade:0.001
		}, function(index) {
		    $.post(url, {
				id:id
			}, function(data) {
				if(data.code == 1){
					layer.msg('Congratulations, delete successfully',{icon:1});
					$('#row_'+id).remove();
					if(typeof(data.turn) != undefined && data.turn ==1){
						setTimeout(function(){
							location.href = data.url;
						},1500);
					}
				}else{
					layer.msg(data.msg,{icon:2});
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

function goto_page(link){
	var page = $('#goto_page').val();
	var purl = link+page;
	location.href = purl;
}
$('header > .toggle').on('click',function() {
	$('body > .menu_left').toggleClass('hide-sidebar');
	
	$('body > .main') .toggleClass('hide-sidebar');
})