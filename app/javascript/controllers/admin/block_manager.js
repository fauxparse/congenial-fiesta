const overlaps = (b1, b2) =>
  b1.y < b2.y + b2.height && b2.y < b1.y + b1.height

export default class BlockManager {
  constructor() {
    this._blocks = {}
    this._eventTarget = new EventTarget()
    this._id = 0
  }

  get blocks() {
    return Object.values(this._blocks)
  }

  block(id) {
    return this._blocks[id]
  }

  insert(block) {
    if (block.id === undefined) {
      block.id = this._id++
    }
    this._blocks[block.id] = block
    this.layoutColumn(block.x)
    return block.id
  }

  update(id, props = {}) {
    const block = this.block(id)
    const x = props.x === undefined ? block.x : props.x
    const y = props.y === undefined ? block.y : props.y
    const height = props.height === undefined ? block.height : props.height

    if (x !== block.x || y !== block.y || height !== block.height) {
      const columns = x === block.x ? [x] : [block.x, x]
      block.x = x
      block.y = y
      block.height = height
      columns.forEach(column => this.layoutColumn(column))
    }
  }

  layoutColumn(column) {
    const blocks = this.blocks.filter(({ x }) => x == column)
    const groups = this.groupBlocks(blocks)
    const laidOut = groups.reduce((memo, group) => [...memo, ...this.layoutGroup(group)], [])
    const event = new CustomEvent('blocks:layout', { detail: laidOut })
    this._eventTarget.dispatchEvent(event)
  }

  sortBlocks(blocks) {
    return blocks.sort((a, b) => {
      if (a.y === b.y) {
        if (a.height === b.height) {
          return b.id > a.id ? 1 : -1
        } else {
          return b.height - a.height
        }
      } else {
        return a.y - b.y
      }
    })
  }

  groupBlocks(blocks) {
    return this.sortBlocks(blocks).reduce((groups, block) => {
      const group = groups.find(g => g.find(b => overlaps(b, block)))
      group ? group.push(block) : groups.push([block])
      return groups
    }, [])
  }

  layoutGroup(group) {
    let columns = 1
    return group.reduce((laidOut, block) => {
      let column = 0
      while (laidOut.find(b => b.column == column && overlaps(block, b))) {
        column++
      }
      if (column >= columns) {
        columns = column + 1
      }
      return [...laidOut, { ...block, column }]
    }, []).map(block => ({ ...block, columns }))
  }

  addEventListener(...args) {
    this._eventTarget.addEventListener(...args)
  }

  removeEventListener(...args) {
    this._eventTarget.removeEventListener(...args)
  }
}
