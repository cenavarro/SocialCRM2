# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@validateRequireFields = ->
  nameField = document.getElementById("client_name")
  descriptionField = document.getElementById("client_description")
  imageField = document.getElementById("client_image")
  isCorrect = true
  alert nameField.value
  alert descriptionField.value
  alert imageField.value
  if not nameField.value? or nameField.value is ""
    nameField.setAttribute "class", "fieldRequire"
    isCorrect = false
  isCorrect