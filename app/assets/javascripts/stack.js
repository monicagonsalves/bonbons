$(document).on('turbolinks:load', function() {
	var count = 0; 

	$('.left-control').click(function(){
		
		var prev_count = count - 1; 
		

		if(count > 0)
		{

			$('.slide_' + count).addClass('animated slideOutLeft');

			setTimeout(function(){
			
				$('.slide_' + count).fadeOut(0).toggleClass('selected');
			
				$('.slide_' + prev_count).fadeIn(90);

				$('.slide_' + prev_count).toggleClass('selected');

				$('.slide_' + count).removeClass('animated slideOutLeft');

				
				count =  prev_count;  	
			

	    	},400);
		}
	});

	$('.right-control').click(function(){
		
		// Select the right node 
		var next_count = count + 1; 

		if( count < $('.slide').length - 1)
		{
			$('.slide_' + count).addClass('animated slideOutRight');

			setTimeout(function(){
			
				$('.slide_' + count).fadeOut(0).toggleClass('selected');
			
				$('.slide_' + next_count).fadeIn(90);

				$('.slide_' + next_count).toggleClass('selected');

				$('.slide_' + count).removeClass('animated slideOutRight');

				count = next_count; 
	    	},400);

		}

	});
});