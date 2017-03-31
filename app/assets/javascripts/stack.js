$(document).on('turbolinks:load', function() {

	$('.left-control').click(function(){
		if($('.selected').prev().length > 0){

			var current = $('.selected');

			current.fadeOut(800, function(){

				$(this).toggleClass('selected');
				$(this).prev().toggleClass('selected');

				var prev_id = $(this).prev().attr('id').split('_').slice(0,2).join('_');

				if($("#" +prev_id).hasClass('front-flip'))
					$("#" + prev_id).toggleClass('front-flip');

				$(this).prev().fadeIn(800);
			});
			
		}
	});

	$('.right-control').click(function(){
		
		// Select the right node 
		if($('.selected').next().length > 0){

			var current = $('.selected');

			current.fadeOut(800, function(){
			
				$(this).toggleClass('selected');
				$(this).next().toggleClass('selected');

				var next_id = $(this).next().attr('id').split('_').slice(0,2).join('_');

				if($('#' + next_id).hasClass('front-flip'))
					$('#' + next_id).toggleClass('front-flip');

				$(this).next().fadeIn(800);

			});

		}
	});
});