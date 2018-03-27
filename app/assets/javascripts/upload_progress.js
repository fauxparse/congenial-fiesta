(() => {
  const getProgressBar = element =>
    element.parentElement.querySelector('.upload-progress')

  const setProgress = (element, progress) => {
    const progressBar = getProgressBar(element)
    progressBar && progressBar.style.setProperty('--progress', progress)
  }

  addEventListener('direct-upload:initialize', event => {
    setProgress(event.target, 0)
  })

  addEventListener('direct-upload:progress', event => {
    setProgress(event.target, event.detail.progress)
  })

  addEventListener('direct-upload:error', event => {
    setProgress(event.target, 0)
  })

  addEventListener('direct-upload:end', event => {
    setProgress(event.target, 100)
  })
})()
