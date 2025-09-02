local Parser = {}

function Parser.new(tokens)
	local self = {
		tokens = tokens,        
		pos = 1,
	}       
	return setmetatable(self, Parser)
end
	
function Parser:current()
    return self.tokens[self.pos]
end

function Parser:consume(expectedType)
    local token = self:current()
    if token and token.type == expectedType then
        self.pos += 1
        return token
    end  
end

function Parser:parse()
    local left = self:parseCompound()       
    while true do
        local combinator = self:consume("COMBINATOR")
        if not combinator then break end        
        local right = self:parseCompound()
        left = {
            type = "combinator",
            op = combinator.value,
            left = left,
            right = right,
        }
    end     
    return left
end

function Parser:parseCompound()
    local selector = {
        type = "compound",
        tag = nil,
        id = nil,
        classes = {},
        attributes = {},
    }
    local token = self:current()        
    if token and token.type == "IDENTIFIER" then
        selector.tag = token.value
        self.pos += 1
        token = self:current()
    end         
    while token do
        if token.type == "DOT" then
            self.pos += 1
            local classToken = self:consume("IDENTIFIER")
            if classToken then
                table.insert(selector.classes, classToken.value)
            end
        elseif token.type == "HASH" then
            self.pos += 1
            local idToken = self:consume("IDENTIFIER")
            if idToken then
                selector.id = idToken.value
            end
        elseif token.type == "LBRACKET" then
            self.pos += 1
            local attrName = self:consume("IDENTIFIER")
            self:consume("EQUALS")
            local valueToken = self:consume("IDENTIFIER") or self:consume("STRING")
            self:consume("RBRACKET")

            if attrName and valueToken then
                selector.attributes[attrName.value] = valueToken.value
            end
        else
            break
        end
        token = self:current()
    end     
    return selector
end

return Parser
 
