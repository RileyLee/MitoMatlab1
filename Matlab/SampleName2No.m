function Number = SampleName2No(Name)
    Number = char(1,6);
    if Name(1) == 'A'
        Number(1) = '1';
    elseif Name(1) == 'H'
        Number(1) = '2';
    end

    Number(2) = Name(3);
    Number(3:4) = Name(5:6);
    
    if Name(9)~='_'
        Number(5:6) = Name(8:9);
    else
        Number(5) = '0';
        Number(6) = Name(8);
    end

return