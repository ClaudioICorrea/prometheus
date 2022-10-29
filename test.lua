function read_luke(path)
    firts_line =true
    i = 10 
    file = io.input(path,'r')
    tabla = {}
    for line in file:lines() do
        if not (firts_line) then
            print(line)
            r = io.read("*n")
            print(line:len())
            print(line)
            --if line:len() == 3 then
            --    r = io.read("*n")
            --end
        end
        firts_line =false






        
        --end    
        r= {}
        --num=line:len()
        --print(line)
        --print(num)

        --if not (firts_line) then
        --        while not (i == 0)  do
        --            i = i -1
        --        s =io.read("*n")
        --        table.insert(r,s)
        --        --print('pase por aca')
        --        --print(line)
        --   end
        --    print(num)
        --    num=line:len()
        --    print(num)
        --end
        --firts_line =false
        --print(line)
        --for s=1, #line do
        --    print(line)
            --num = io.read("*n")
            --table.insert(r, num)
        --end
        
        --table.insert(r,io.read("*n"))

        --r = io.read("*n")
        
        --num=line:len()
        --print(line)
        --print(num)
        --table.insert(tabla,r)
    end
        io.close()
    return tabla
end

function show_tabla(tabla)
    for i,line in pairs(tabla) do
        print(line[1],line[2])
    end
end




conn = read_luke('conn.txt')
--node = read_luke('node.txt')

--show_tabla(conn)
--show_tabla(node)





