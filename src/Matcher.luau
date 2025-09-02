local Matcher = {}

------------------------------------------------------------------------   

local function matchProperty(instance: Instance, property: string, value: string): boolean	  
	if value:match('^".*"$') then value = value:sub(2, #value - 1) end    
	return tostring(instance[property]) == value 	 	   
end

local function matchesCompound(instance: Instance, selector): boolean       
	if selector.tag and selector.tag ~= "*" and instance.ClassName ~= selector.tag then return false end    
	if selector.id and instance.Name ~= selector.id then return false end                       
	for _, class: string in selector.classes or {} do
		if not instance:HasTag(class) then return false end
	end                                                                  
	for property: string, value: any in selector.attributes or {} do    
		local s, propertyMatches = pcall(matchProperty, instance, property, value)   
		if not s then return false end 		
		if not propertyMatches then return false end   	
	end         
	return true
end

local function matchRecursive(root: Instance, selector, selectAll: boolean)                  
	local results = {}                             
	if selector.type == "compound" then 
		local function scan(obj: Instance)      
			if matchesCompound(obj, selector) then
				table.insert(results, obj)
			end
			for _, child in obj:GetChildren() do
				scan(child)
			end
		end
		scan(root)          
	elseif selector.type == "combinator" then
		local leftMatches = matchRecursive(root, selector.left)

		for _, left in leftMatches do
			local op = selector.op
			local rightSel = selector.right

			if op == ">" then
				for _, child in left:GetChildren() do
					if matchesCompound(child, rightSel) then
						table.insert(results, child)
					end
				end

			elseif op == "+" then
				local parent = left.Parent
				if parent then
					local children = parent:GetChildren()
					for i = 1, #children - 1 do
						if children[i] == left then
							local nextSibling = children[i + 1]
							if matchesCompound(nextSibling, rightSel) then
								table.insert(results, nextSibling)
							end
							break
						end
					end
				end

			elseif op == "~" then
				local parent = left.Parent
				if parent then
					local foundLeft = false
					for _, sibling in parent:GetChildren() do
						if sibling == left then
							foundLeft = true
						elseif foundLeft then
							if matchesCompound(sibling, rightSel) then
								table.insert(results, sibling)
							end
						end
					end
				end

			elseif op == " " then               
				local function scan(obj)
					for _, child in obj:GetChildren() do            
						if matchesCompound(child, rightSel) then
							table.insert(results, child)
						end
						scan(child)
					end
				end
				scan(left)

			else
				warn(`Unsupported combinator "{op}"`)       
			end
		end
	end
	return results
end

------------------------------------------------------------------------   

function Matcher.selectAll(root: Instance, parsedSelector)
	return matchRecursive(root, parsedSelector, true)       
end

--function Matcher.select(root: Instance, parsedSelector)                                          
--	return Matcher.selectAll(root, parsedSelector)
--end         

------------------------------------------------------------------------   

return Matcher
