

function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function read_luke(path)
    firts_line =true
    
    file = io.input(path,'r')
    tabla = {}
    for line in file:lines() do
        str ={}
        r = {}
        if not firts_line then
                str = split (line, " ")
                for i,num in pairs(str) do
                    table.insert(r,tonumber(num))
                end     
            table.insert(tabla,r)
        end
        firts_line =false
    end
        io.close()
    return tabla
end

function show_tabla(tabla)
    for i,line in pairs(tabla) do
        str = ""
        for j,elent in  pairs(line) do 
            str = str .." ".. tostring(line[j])
        end
        print(str)
    end
end




conn = read_luke('conn.txt')
--node = read_luke('node.txt')

show_tabla(conn)
--show_tabla(node)




