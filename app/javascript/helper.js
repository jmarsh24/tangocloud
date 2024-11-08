function formatDuration (secs) {
  const date = new Date(null)
  date.setSeconds(secs)
  const dateString = date.toISOString()

  return secs > 60 * 60 ? dateString.substring(11, 19) : dateString.substring(14, 19)
}

function dispatchEvent (element, type, data = null) {
  if (typeof element === 'string') { element = document.querySelector(element) }
  element.dispatchEvent(new CustomEvent(type, { detail: data }))
}

export { 
  dispatchEvent, 
  formatDuration
}