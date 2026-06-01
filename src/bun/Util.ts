export function escapeNonAscii(source: string) {
  return source.replace(/[^\x00-\x7F]/g, (char) => {
    const codePoint = char.codePointAt(0)

    if (codePoint == null) {
      return char
    }

    if (codePoint <= 0xffff) {
      return `\\u${codePoint.toString(16).padStart(4, "0")}`
    }

    const adjusted = codePoint - 0x10000
    const high = 0xd800 + (adjusted >> 10)
    const low = 0xdc00 + (adjusted & 0x3ff)

    return `\\u${high.toString(16).padStart(4, "0")}\\u${low.toString(16).padStart(4, "0")}`
  })
}