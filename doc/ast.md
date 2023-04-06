# Simplec - AST Documentation

The abstract syntax tree is expressed as an object hierarchy with nested objects and can be exported to YAML and JSON.

This documentation contains the schemas of all nodes in the abstract syntax tree.

## General

### Block node
```yaml
block:
    id: integer
    file: string
    line: integer
    column: integer
    parameters: array
    body: array containing the expression statements in order
    symbols: array of symbols
```

_Example:_
```yaml
block:
    id: 1
    file: 'source_file.sc'
    line: 1
    column: 1
    parameters:
        - ...
    body:
        - ...
    symbols:
        - ...
```

The block node contains multiple expression statements. It is used for function bodies, if statements, etc. and is the root node of every abstract syntax tree. Its value is the last expression in the array.

Category: `/block`

### Symbol node
```yaml
symbol:
    id: integer
    file: string
    line: integer
    column: integer
    identifier: string
    type: string
    definition: block or literal
```

_Example:_
```yaml
symbol:
    id: 1
    file: 'source_file.sc'
    line: 1
    column: 1
    identifier: 'main'
    definition:
        ...
```

Category: `/symbol`

## Literals

### Integer literal node
```yaml
integer:
    id: integer
    file: string
    line: integer
    column: integer
    type: always 'int32'
    value: integer
```

_Example:_
```yaml
integer:
    id: 1
    file: 'source_file.sc'
    line: 1
    column: 1
    type: 'int32'
    value: 42
```

Category: `/literals/integer`

## Calls

### Call node
```yaml
call:
    id: integer
    file: string
    line: integer
    column: integer
    identifier: string
    symbol: null, extern or id
    arguments: array
```

_Example:_
```yaml
call:
    id: 1
    file: 'source_file.sc'
    line: 1
    column: 1
    identifier: 'my_function'
    symbol: 4
    arguments:
        - ...
```

Category: `/call`
