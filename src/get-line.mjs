/**
 * Prompt the user for
 * @param {string} prompt
 * @returns {string} The line
 */
export const { MAX_SAFE_INTEGER } = Number

export async function getLine(prompt) {
    if (window === globalThis)
        throw Error('Cannot get line in browser environment')

    const readline = await import('node:readline')
}
