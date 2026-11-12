// Read-only Figma Plugin API script that exports the `02 Semantics` colors and corner radii as tokens/colors.json.
// Run it with the Figma MCP `use_figma` tool on the Tokens file (5iR1wP3qoTT4uD6d20ekVv), save the returned
// JSON as tokens/colors.json, then run `node tokens/generate.mjs`.
const order = ['Light', 'Dark', 'EVA Light', 'EVA Dark', 'Heritage Luxury Light', 'Heritage Luxury Dark']
const collections = await figma.variables.getLocalVariableCollectionsAsync()
const semantics = collections.find((c) => c.name === '02 Semantics')
const all = await figma.variables.getLocalVariablesAsync()
const byId = Object.fromEntries(all.map((v) => [v.id, v]))
const hex2 = (x) => Math.round(x * 255).toString(16).padStart(2, '0').toUpperCase()
// Follow aliases: semantic -> semantic (same mode) or -> primitive (its only mode). Alpha primitives are stored
// as `{ color: alias, opacity: 0-100 }`, so their opacity is carried into the resolved color.
const resolve = (variable, modeId) => {
  let value = variable.valuesByMode[modeId]
  let alpha = 1
  for (;;) {
    if (value && value.type === 'VARIABLE_ALIAS') {
      const target = byId[value.id]
      const collection = collections.find((c) => c.id === target.variableCollectionId)
      value = target.valuesByMode[collection.id === semantics.id ? modeId : collection.modes[0].modeId]
    } else if (value && value.color && value.opacity !== undefined) {
      alpha *= value.opacity / 100
      value = value.color
    } else {
      break
    }
  }
  return { ...value, a: (value.a ?? 1) * alpha }
}
const hex = (c) => hex2(c.r) + hex2(c.g) + hex2(c.b) + (c.a < 1 ? hex2(c.a) : '')
const modes = order.map((name) => {
  const mode = semantics.modes.find((m) => m.name === name)
  if (!mode) throw new Error(`Missing mode ${name}`)
  return mode
})
const colors = {}
for (const id of semantics.variableIds) {
  const variable = byId[id]
  if (variable.resolvedType !== 'COLOR') continue
  colors[variable.name] = Object.fromEntries(modes.map((m) => [m.name, hex(resolve(variable, m.modeId))]))
}
// Corner radii (`radius/*`) follow the brand shape, so they have a value per mode too.
const resolveFloat = (variable, modeId) => {
  let value = variable.valuesByMode[modeId]
  while (value && value.type === 'VARIABLE_ALIAS') {
    const target = byId[value.id]
    const collection = collections.find((c) => c.id === target.variableCollectionId)
    value = target.valuesByMode[collection.id === semantics.id ? modeId : collection.modes[0].modeId]
  }
  return value
}
const radii = {}
for (const id of semantics.variableIds) {
  const variable = byId[id]
  if (variable.resolvedType !== 'FLOAT' || !variable.name.startsWith('radius/')) continue
  radii[variable.name] = Object.fromEntries(modes.map((m) => [m.name, resolveFloat(variable, m.modeId)]))
}
return JSON.stringify(
  {
    source: 'Figma Tokens file 5iR1wP3qoTT4uD6d20ekVv, collection 02 Semantics. Export with tokens/export-figma.js; do not edit by hand.',
    modes: order,
    colors,
    radii,
  },
  null,
  2,
)
