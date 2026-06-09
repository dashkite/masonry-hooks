import * as Fn from "@dashkite/joy/function"
import * as M from "@dashkite/masonry"

globalThis["@dashkite/masonry-hooks"] ?=
  read: []
  write: []

registry = globalThis["@dashkite/masonry-hooks"]

register = ( name, handler ) ->
  if ( handlers = registry[ name ] )?
    handlers.push Fn.tee handler
  else
    throw new Error "masonry-hooks:
      unsupported hook [ #{ name } ]"

run = ( name ) ->
  Fn.tee ( context ) ->
    handlers = registry[ name ]
    if handlers.length > 0
      f = Fn.flow handlers
      f context

read = Fn.flow [
  M.read
  run "read"
]

write = ( args... ) ->
  Fn.flow [
    run "write"
    M.write args...
  ]

export { 
  register
  read
  write
}