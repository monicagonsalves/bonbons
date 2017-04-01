$(document).on('turbolinks:load', function() {
	var count = 0; 
	var flipped_slides = [];

	$('.flashcard-container .flashcard').click(function(event){
		console.log("I'm fired too");
		var card_id = "#" + $(this).attr('id') + "_top";


		var slide_id = null;

		$(card_id).attr('class').split(/\s+/).forEach(function(n){
  			if(n.match(/slide_[0-9]+/)){ 
      			slide_id = n;  
      			return false;
   			}
		})

		// First check if the slide is already in the array. If it isn't, add it.
		// IF it is, don't add it. 
		flipped_slides.push(slide_id);

	
	});

	$('.left-control').click(function(){
		
		var prev_count = count - 1; 


		if(count > 0)
		{

			$('.slide_' + count).addClass('animated slideOutLeft');

			setTimeout(function(){

				if($('.slide_' + count).closest('.face').hasClass('front-flip'))
					$('.slide_' + count).closest('.face').toggleClass('front-flip');
			
				$('.slide_' + count).fadeOut(0).toggleClass('selected');
			
				$('.slide_' + prev_count).fadeIn(250);

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

				if($('.slide_' + count).closest('.face').hasClass('front-flip'))
					$('.slide_' + count).closest('.face').toggleClass('front-flip');

				$('.slide_' + count).fadeOut(0).toggleClass('selected');
			
				$('.slide_' + next_count).fadeIn(250);

				$('.slide_' + next_count).toggleClass('selected');

				$('.slide_' + count).removeClass('animated slideOutRight');

				count = next_count; 
	    	},400);

		}

	});
});