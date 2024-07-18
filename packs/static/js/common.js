	// Turn on the word slide-in effect
window.onload = function(){
	$(".connect p").eq(0).animate({"left":"0%"}, 600);
	$(".connect p").eq(1).animate({"left":"0%"}, 400);
};
// jquery.validate form validation
$(document).ready(function(){
	// Login form verification

	$('#submit').click(function () {
		var data=$('form').serializeArray();
		$.post($('form').attr('action'), data, function(data, textStatus, xhr) {
			layer.msg(data.msg);
			if(data.code){
			    setTimeout(function () {
                    window.location.href=data.url;
                },2000);

			}
		},'json');
    });


	$.supersized({

        // Function
        slide_interval     : 4000,    // length between transitions
        transition         : 1,    // 0 - None, 1 - Fade, 2 - Slide top, 3 - Slide right, 4 - Slide bottom, 5 - Slider left, 6 - Carousel right, 7 - Carousel left
        transition_speed   : 1000,    // Transformation speed
        performance        : 1,    // 0 - normal, 1 - mixed speed/quality, 2 - better image quality, triple best conversion speed // (only for Firefox/IE, not Webkit)

        // size and location
        min_width          : 0,    // Minimum allowed width in pixels
        min_height         : 0,    // Minimum allowed height in pixels
        vertical_center    : 1,    // vertically centered background
        horizontal_center  : 1,    // horizontal center background
        fit_always         : 0,    // Images will never exceed the width or height of the browser (min. dimensions are ignored)
        fit_portrait       : 1,    // Portrait images will not exceed browser height
        fit_landscape      : 0,    // The landscape image will not exceed the width of the browser

        // components
        slide_links        : 'blank',    // Individual links for each slide (options: false, 'people', 'name', 'null')
        slides             : [    // Slideshow image
                                 {image : '/packs/static/img/login.jpg'},
                       ]

    });
});
