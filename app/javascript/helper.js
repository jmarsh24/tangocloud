function formatDuration(secs) {
  const date = new Date(null);
  date.setSeconds(secs);

  const hours = date.getUTCHours();
  const minutes = date.getUTCMinutes();
  const seconds = date.getUTCSeconds();

  if (secs >= 3600) {
    return `${hours}:${minutes}:${seconds.toString().padStart(2, '0')}`;
  } else {
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
  }
}

function dispatchEvent (element, type, data = null) {
  if (typeof element === 'string') { element = document.querySelector(element) }
  element.dispatchEvent(new CustomEvent(type, { detail: data }))
}

export { 
  dispatchEvent, 
  formatDuration
}