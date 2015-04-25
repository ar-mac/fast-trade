# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.offer-list-item').on('mouseenter', ->
    $(this).find('.offer-button').fadeIn 'fast'
    return
  ).on('mouseleave', ->
    $(this).find('.offer-button').fadeOut 'fast'
    return
  )
return