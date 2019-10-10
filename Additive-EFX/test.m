function bool_final = test(time,m,n)
for i = 1:time
    bool = main(m,n);
    if bool == 0
        bool_final = 0;
        return
    end
end
bool_final = 1;
end

