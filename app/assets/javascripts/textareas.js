(() => {
  addEventListener('turbolinks:load', () => {
    autosize(document.querySelectorAll('textarea[data-autosize]'))
  })

  const updateWordCount = (textArea, counter) => {
    const min = parseInt(counter.getAttribute('data-min'), 10)
    const max = parseInt(counter.getAttribute('data-max'), 10)
    const count = countWords(textArea.value)
    const progress = Math.min(min, count) * 100.0 / min
    counter.style.setProperty('--progress', progress)
    counter.classList.toggle('word-limit-exceeded', count > max)
  }

  const countWords = string =>
    (string
      .replace(/[^\w\s]|_/g, '')
      .replace(/\s+/g, ' ')
      .toLowerCase()
      .match(/\b[a-z\d]+\b/g) || []
    ).length

  const parentField = element => {
    while (element && !element.classList.contains('form-field')) {
      element = element.parentElement
    }
    return element
  }

  addEventListener('turbolinks:load', () => {
    Array
      .from(document.querySelectorAll('.text-area-word-count'))
      .forEach(counter => {
        const textArea = parentField(counter).querySelector('textarea')
        const updater = () => updateWordCount(textArea, counter)
        textArea.addEventListener('change', updater)
        textArea.addEventListener('input', updater)
        updater()
      })
  })
})()
