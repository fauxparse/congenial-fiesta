(() => {
  addEventListener('turbolinks:load', () => {
    Array.from(document.querySelectorAll('.drop-target')).forEach(target => {
      // const content = target.parentNode.querySelector('.drop-content')
      const content = target.nextSibling
      new Drop({
        target,
        content,
      })
    })
  })
})()
