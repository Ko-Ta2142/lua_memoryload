# lua require memoryload
メモリ上からluaコードをロードします。  
require(module)すると空のmemoryload.onloadが呼ばれるので、バイナリの文字列をreturnしてあげてください。  
lua5.1/5.2両対応。

require/load lua file on memory.  
request override "memoryload.onload" function.

## sample

```lua
require("memoryload")
-- debug logging function override.
memoryload.onprint = function(s)
	debug_logprint(s)
end
-- load function override. return binary string(byte)
-- c_function_load is host application function
memoryload.onload = function(filename)
    return c_function_load(filename)
end

-- call memoryload.onload
require("hoge")
require("hogehoge")

function main()
    
end
```