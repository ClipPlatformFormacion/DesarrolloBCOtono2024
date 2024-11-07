codeunit 50154 "Gold Customer Level Management" implements ICustomerLevel
{
    procedure GetDiscount(): Decimal
    begin
        exit(20);
    end;
}