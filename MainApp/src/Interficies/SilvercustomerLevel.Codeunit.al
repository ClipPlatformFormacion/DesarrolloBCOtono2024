codeunit 50104 "Silver customer Level" implements ICustomerLevel
{
    procedure GetDiscount(): Decimal
    begin
        exit(10);
    end;
}