local Selectors = {}

local Tokens = require('@self/Tokenizer') 	 	
local Parser = require('@self/Parser') 		 		
local Matcher = require('@self/Matcher')

function Selectors.select(root: Instance, selector: string): Instance? 			
	local tokenList = Tokens.tokenize(selector) 	 	
	return Matcher.selectAll(root, Parser.new(selector):parse())[1] 	 	 	  	 	 
end   	

function Selectors.selectAll(root: Instance, selector: string): {Instance?}  			
	local tokenList = Tokens.tokenize(selector) 	 	
	return Matcher.selectAll(root, Parser.new(selector):parse())  	 	
end   	  	 	   	  	  	   	  	

return Selectors  	      
