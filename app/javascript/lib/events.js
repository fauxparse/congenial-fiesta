export const EVENTS = {
  touch: {
    start: 'touchstart',
    move: 'touchmove',
    stop: 'touchend'
  },
  mouse: {
    start: 'mousedown',
    move: 'mousemove',
    stop: 'mouseup'
  }
}

export const eventPosition = event => {
  const action = event.touches && event.touches[0] || event
  return { x: action.clientX, y: action.clientY }
}

export const absolutePosition = element => {
  let x = 0
  let y = 0
  while (element) {
    x += element.offsetLeft
    y += element.offsetTop
    element = element.offsetParent
  }
  return { x, y }
}
