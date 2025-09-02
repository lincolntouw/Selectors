local Tokenizer = {}
Tokenizer.patterns = {
    { type = "COMBINATOR",  pattern = "^>" },
    { type = "DOT",         pattern = "^%." },
    { type = "HASH",        pattern = "^#" },
    { type = "LBRACKET",    pattern = "^%[" },
    { type = "RBRACKET",    pattern = "^%]" },
    { type = "EQUALS",      pattern = "^=" },
    { type = "STRING",      pattern = '^"([^"]*)"' },     
    { type = "STRING",      pattern = "^'([^']*)'" },  
    { type = "IDENTIFIER",  pattern = "^[%w_]+" },
    { type = "WHITESPACE",  pattern = "^%s+" },                  
}       

function Tokenizer.tokenize(input)
    local tokens = {}
    local i = 1
    while i <= #input do
        local chunk = input:sub(i)
        local matched = false
        for _, spec in Tokenizer.patterns do                         
            local s, e = chunk:find(spec.pattern)
            if s == 1 then
                local text = chunk:sub(s, e)
                if spec.type ~= "WHITESPACE" then
                    table.insert(tokens, { type = spec.type, value = text })
                end
                i = i + (e - s + 1)
                matched = true
                break
            end
        end
        if not matched then
            error(
                ("Unexpected character at position %d: '%s'")
                :format(i, chunk:sub(1,1))
            )
        end
    end
    return tokens
end

return Tokenizer
