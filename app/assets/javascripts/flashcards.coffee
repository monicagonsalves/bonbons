# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  current_num_words = 0

  make_input = (c) ->
    arr_i = c - 1
    "<div class='word-input'><label for='word_#{arr_i}'>Word #{c}: </label><input type='text' name='word[#{arr_i}]' id='word_#{arr_i}' /><br/><label for='word_#{arr_i}_tags'>Word specific tags: </label><input type='text' name='word_tags[#{arr_i}]' id='word_#{arr_i}_tags'></div>"

  $("#add_word_fields").click -> 
    num_words = $("#num_words_to_add").val()

    start_i = parseInt(current_num_words)
    end_i = parseInt(current_num_words) + parseInt(num_words)
    for i from [start_i...end_i]
      $("#words").append(make_input(i+1)) 

    current_num_words = end_i

  # I don't know why it works to just toggle the front flip class. 
  # But, I'm guessing the reason you have to toggle the class on the object with the 
  # flashcard class and not the object with the front class is because the animation
  # is associated with the flashcard class. 
  $('.flashcard-container .flashcard').on 'click', (event) ->
    # Do not want to flip the card when the user clicks a link!
    console.log "I'm fried"
    unless $(event.target).is('a') or $(event.target).hasClass('delete-link')
      $(this).toggleClass('front-flip')

  $('.tag-link').on 'click', (event) -> 
    event.stopPropagation()

    # Do not want to slide out all tag lists, just the one associated with this 
    # particular card!
    card_id = $(this).attr('data-card-id')
    $(".tag-list.#{card_id}").slideToggle( "slow");
    
    event.preventDefault()

  $('.toggle-all-tags').on "change", (event) ->
    $(".tag-list").slideToggle("slow");
    event.preventDefault()

$(document).on('turbolinks:load', ready) 
