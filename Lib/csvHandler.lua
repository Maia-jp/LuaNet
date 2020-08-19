local csv = {}
math.randomseed(os.time())
--AUX
function shuffle(array)
    -- fisher-yates
    local output = { }
    local random = math.random

    for index = 1, #array do
        local offset = index - 1
        local value = array[index]
        local randomIndex = offset*random()
        local flooredIndex = randomIndex - randomIndex%1

        if flooredIndex == offset then
            output[#output + 1] = value
        else
            output[#output + 1] = output[flooredIndex + 1]
            output[flooredIndex + 1] = value
        end
    end

    return output
end

-- read csv
function csv.readfile(arq)
   local file = io.open(arq, "r");
 local arr = {}
 for line in file:lines() do
    table.insert (arr, line);
 end
return arr
end
-- line to array
function csv.parseCSVLine (line,sep) 
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then append it
				-- this is the way to "escape" the quote char in a quote. example:
				--   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(line,pos))
				break
			end 
		end
	end
	return res
end

--Export the csv to train
function csv.totrain(arq,sep)
  sep = sep or ","
  --Load the file
  local file = csv.readfile(arq)
  --Parse data
  local data_parse = {}
  for i=2, #file do
    table.insert(data_parse,csv.parseCSVLine(file[i],sep))
  end
  -- shuffle the data
  local data = shuffle(data_parse)
  return data
end
return csv
