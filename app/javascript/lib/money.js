import { padStart } from 'lodash'

export default amount =>
  [
    '$',
    amount < 0 ? '-' : '',
    Math.floor(Math.abs(amount / 100)).toString(),
    '.',
    padStart((Math.abs(amount) % 100).toString(), 2, '0')
  ].join('')
