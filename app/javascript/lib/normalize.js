import deburr from 'lodash/deburr'

const normalize = str => deburr(str).toLowerCase()

export default normalize
