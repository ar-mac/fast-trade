# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.offer-list-item').on('mouseenter', ->
    $(this).find('.offer-buttons').fadeIn 'fast'
    return
  ).on('mouseleave', ->
    $(this).find('.offer-buttons').fadeOut 'fast'
    return
  )
  $('.offer-buttons').on('mouseenter','.btn', ->
    descrText = $(this).data('description')
    descrItem = $(this).closest('.offer-buttons').find('.description')
    descrItem.html(descrText)
    descrItem.addClass('alert alert-info alert-narrow')
    return
  )
  $('.btn-group').on('mouseleave', ->
    descrItem = $(this).closest('.offer-buttons').find('.description')
    descrItem.text('')
    descrItem.removeClass('alert alert-info alert-narrow')
    return
  )
return
