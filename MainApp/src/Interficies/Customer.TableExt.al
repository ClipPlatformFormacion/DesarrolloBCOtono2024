tableextension 50106 Customer extends Customer
{
    fields
    {
        field(50100; "Customer Level"; Enum "Customer Level")
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Handled: Boolean;
            begin
                case Rec."Customer Level" of
                    Rec."Customer Level"::" ":
                        Rec.Validate(Discount, 0);
                    Rec."Customer Level"::Bronze:
                        Rec.Validate(Discount, 5);
                    Rec."Customer Level"::Silver:
                        Rec.Validate(Discount, 10);
                    else begin
                        OnValidateCustomerLevelOnBeforeUnknownCustomerLevelError(Rec, Handled);
                        if not Handled then
                            Error('Customer Level %1 unknown', Rec."Customer Level");
                    end;
                end;
            end;
        }
        field(50101; "Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    [IntegrationEvent(false, false)]
    local procedure OnValidateCustomerLevelOnBeforeUnknownCustomerLevelError(var Rec: Record Customer; var Handled: Boolean)
    begin
    end;
}