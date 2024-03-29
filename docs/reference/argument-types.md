# Argument Types

In command documentation, you've probably seen one of these:

- `<reason:string...>`
- `<target:user[]>`
- `[time:duration]`

These are argument types. They are a way for users to identify what type is required for a certain
argument when giving them a value. These are purely a documentation visualisation rather than
something used by the bot itself.

As a quick breakdown, this is what each part means (in this case, `<reason:string...>`):

- `<` and `>` are the [requirements](#argument-requirements).
- `reason` is the name of the argument.
- `:` is a separator between the name and the type.
- `string` is the type of the argument.
- `...` is a type modifier.

## Argument Requirements

Arguments are surrounded by either `[]` or `<>`. These show the requirement level of the argument.
Optional arguments are surrounded by `[]` and required arguments are surrounded by `<>`.

### Optional Argument Defaults

Some optional arguments will have their default value in parentheses at the end of the string (e.g.,
`[amount:number(1)]`).

## Type Modifiers

Type modifiers change the way a type is interpreted, including taking multiple of the same type as
one argument.

### Array Types (`[]`)

Array types are a modifier that show that an argument can take multiple of the same type.

### Greedy Types (`...`)

Greedy types are a modifier that is only used at the end of an argument list and is always used with
strings that take the rest of the input and turn it into one argument.

### Or Types (`|`)

Or types are a modifier that show that an argument can take multiple types. This is usually used for
commands that target discord entities (e.g., users, roles, channels, etc.).
