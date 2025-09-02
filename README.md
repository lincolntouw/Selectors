# Selectors
CSS-like selectors for Luau.
## Setup   
Append `Tokenizer.luau`, `Parser.luau`, and `Matcher.luau` under `index.luau` when using within Roblox (all should be ModuleScripts).
Your hierarchy should appear as so:
```
index.luau
├── Tokenizer.luau
├── Parser.luau
└── Matcher.luau
```    
## Syntax   
### Basics
`*` Wildcard selector

`#Name` Select by Instance name       

`.tag` Select by tags

`[property=value]` Select by properties   
### Combinators            
`>` Child combinator

` ` Descendant combinator

`~` Subsequent sibling combinator   

`+` Next-sibling combinator   

## Examples
This module was made to have similar functionality to [CSS selectors](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_selectors), and currently contains two functions: `select(root, selector)` and `selectAll(root, selector)`.      
Below are some usage examples:


### `select(root: Instance, selector: string): Instance?`    
Searches the `root`'s descendants for the first Instance that matches the specified `selector`, and returns the found Instance (if any).
```luau
local Selectors = require("Selectors")
Selectors.select(workspace, "Part#coolpart > BlockMesh")
-- Searches for a descendant of the Workspace that is a Part, has the name "coolpart", and has a BlockMesh as a direct child.
```
### `selectAll(root: Instance, selector: string): {Instance?}`             
Searches the `root`'s descendants for any Instances that match the specified `selector`, then compiles and returns an array containing those Instances. 
```luau       
local Selectors = require("Selectors")
Selectors.selectAll(workspace, "*.spawnparts[Anchored=true]")    
-- Searches for any descendant of the Workspace that has the tag "spawnparts" and has the "Anchored" property set to true.    
```
