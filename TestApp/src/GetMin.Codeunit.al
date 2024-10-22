codeunit 50151 "Get Min"
{
    procedure GetMin(Param1: Decimal; Param2: Decimal): Decimal
    begin
        // if Param1 < Param2 then
        //     exit(Param1)
        // else
        //     exit(Param2);
        if Param1 < Param2 then
            exit(Param1);
        exit(Param2);
    end;
}