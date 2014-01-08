scope = {}

change_search_button_state = ->
  if scope.file_input[0].files[0]
    scope.search_button.prop('disabled', false)
  else
    scope.search_button.prop('disabled', true)
  return undefined

prepare_data = (data) ->
  json = {
    size: data[0],
    chunks: [
      data[1],
      data[2]
    ]
  }

  return JSON.stringify(json)

show_spinner = (show) ->
  if show == true
    scope.search_button.html('Searching <img src="/assets/spinner.gif" />')
  else
    scope.search_button.html('Search!')

clear_file_input = ->
  scope.file_input.wrap('<form></form>').parent('form').trigger('reset')
  scope.file_input.unwrap()
  change_search_button_state()
  show_spinner(true)

  return undefined

insert_data_into_form = (data) ->
  scope.hidden_data.val(data)
  clear_file_input()

  $('#search_form').submit()

  return undefined

read_chunk = (nb_chunks, data) ->
  return (chunk) ->
    reader = new FileReader()
    reader.onloadend = (evt) ->
      if evt.target.readyState = FileReader.DONE
        data.push(evt.target.result)
        if (nb_chunks -= 1) == 0
          json = prepare_data(data)
          insert_data_into_form(json)
    reader.readAsDataURL(chunk)

prepare_file = ->
  file = scope.file_input[0].files[0]
  size = file.size
  chunk_size = 64 * 1024

  if not file.type.match 'video.*'
    alert('Please select a video file.')
    return undefined

  chunks = [file.slice(0, chunk_size), file.slice(size - chunk_size, size)]
  data = [size]

  read = read_chunk(chunks.length, data)
  read(chunk) for chunk in chunks

  return undefined

bind_form_events = ->
  scope.file_input = $("form input[name='file_input']")
  scope.file_button = $("form button[name='file_button']")
  scope.search_button = $("form button[name='search_button']")
  scope.hidden_data = $("form input[name='hidden_data']")

  scope.file_button.on 'click', (evt) ->
    scope.file_input.click()
    return undefined

  scope.file_input.on 'change', (evt) ->
    change_search_button_state()
    return undefined

  scope.search_button.on 'click', (evt) ->
    evt.preventDefault()
    prepare_file()
    return undefined

  return undefined

$(document).on 'ready', ->
  bind_form_events()
  return undefined
