# lua require memoryload
メモリ上からluaコードをロードします。  
require(module)すると空のmemoryload.onloadが呼ばれるので、バイナリの文字列をreturnしてあげてください。  
lua5.1/5.2両方で使用可能です。unicode16系の変換があれば対応可能です。

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

## unicode16
bom判定機構が組み込まれています。  
もし対応させる場合は変換するfunctionを定義してあげてください。

if support unicode16 format, override "memoryload.decodeutf16le/be" function.

```lua
memoryload.decodeutf16le = nil;
memoryload.decodeutf16be = nil;

memoryload.decodeutf16le = function(s)
    return custom_unicode16leto8(s)
end
```