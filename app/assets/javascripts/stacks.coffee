# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#jQuery ->
ready = ->
  $('#auto-generated-stacks > ul > li').on 'mousedown', (event) ->
  	console.log "Clicked an auto generated list item " 

  	div_id = $(this).attr('data-div-id')

  	$(this).addClass("selected")
  	$(this).siblings("li").removeClass("selected")

  	$("##{div_id}").removeClass("hide")
  	$("##{div_id}").siblings("div").addClass("hide")

  	event.preventDefault()

$(document).on('turbolinks:load', ready) 