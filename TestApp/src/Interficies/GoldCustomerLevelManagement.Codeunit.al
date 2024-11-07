codeunit 50154 "Gold Customer Level Management"
{
    [EventSubscriber(ObjectType::Table, Database::Customer, OnValidateCustomerLevelOnBeforeUnknownCustomerLevelError, '', false, false)]
    local procedure Customer_OnValidateCustomerLevelOnBeforeUnknownCustomerLevelError(var Rec: Record Customer; var Handled: Boolean)
    begin
        if Rec."Customer Level" <> Rec."Customer Level"::Gold then
            exit;

        Handled := true;
        Rec.Validate(Discount, 20);
    end;

}