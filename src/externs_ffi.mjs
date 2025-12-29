import { stdin as input, stdout as output } from 'node:process'
import { createInterface } from 'node:readline'

const rl = createInterface({ input, output })
let cbDepth = 0

export function getLine(prompt, cb) {
    const fnDepth = cbDepth
    cbDepth++
    rl.question(prompt, (answer) => {
        cb(answer)
        if (cbDepth === fnDepth) rl.close()
        cbDepth--
    })
}
