tableextension 50106 Customer extends Customer
{
    fields
    {
        field(50100; "Customer Level"; Enum "Customer Level")
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ICustomerLevel: Interface ICustomerLevel;
            begin
                ICustomerLevel := Rec."Customer Level";
                Rec.Validate(Discount, ICustomerLevel.GetDiscount());
            end;
        }
        field(50101; "Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }
}