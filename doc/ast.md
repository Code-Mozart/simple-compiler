# Simplec - AST Documentation

The abstract syntax tree is expressed as an object hierarchy with nested objects and can be exported to YAML
and JSON (not yet supported).

This documentation contains the schemas of all nodes in the abstract syntax tree.

## General

All nodes have the following properties:

```yaml
id: integer, a unique identifier for this node
file: string, the absolute file path of the source file
line: integer, the line number of the first character of this node
column: integer, the column number of the first character of this node
```

### Block node

```yaml
block:
  ...
  parameters: array, a list of variable nodes (currently always empty)
  body: array, contains the expression statements in order
  symbols: array, the symbols defined in this block (not yet implemented)
```

The block node contains multiple expression statements. It is used for function bodies, if statements, etc.
and also is the root node of every abstract syntax tree. Its value is the last expression in the array.

### Symbol node _(not yet implemented)_

```yaml
symbol:
  ...
  identifier: string, the name identifying this symbol
  type: string, the type of this symbol
  type_definition: null, integer or string, null if the type is unresolved, the id of the type or the tag 'extern' to indicate that the type is defined somewhere else
  definition: object, a block node for functions or a literal node for global variables
```

## Literals

### Integer literal node _(not yet implemented)_

```yaml
integer:
  ...
  type: string, always 'int32'
  type_definition: string, always 'extern'
  value: integer, the integer value of this literal
```

### String literal node

```yaml
string:
  ...
  type: string, always 'string' (not yet implemented)
  type_definition: string, always 'extern' (not yet implemented)
  value: string, the string value of this literal
```

## Calls

### Call node

```yaml
call:
  ...
  identifier: string
  definition: null, integer or string, null if the symbol is unresolved, the id of the symbol or the tag 'extern' to indicate that the symbol is defined somewhere else
  arguments: array
```
