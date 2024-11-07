codeunit 50103 "Bronze Customer Level" implements ICustomerLevel
{
    procedure GetDiscount(): Decimal
    begin
        exit(5);
    end;
}