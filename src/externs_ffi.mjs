import { stdin as input, stdout as output } from 'node:process'
import { createInterface } from 'node:readline'

const rl = createInterface({ input, output })
const cbStack = [false, true]

export function getLine(prompt, cb) {
    const fnDepth = cbStack[0] ? 1 : 0
    cbStack[fnDepth] = true
    cbStack[1 - fnDepth] = false
    console.log(cbStack)
    rl.question(prompt, (answer) => {
        cb(answer)

        // if the value wasn't flipped there is no nested getLine
        if (cbStack[fnDepth]) rl.close()
    })
}
