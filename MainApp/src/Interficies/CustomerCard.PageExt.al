pageextension 50110 "Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Customer Level"; Rec."Customer Level")
            {
                ApplicationArea = All;
                ToolTip = 'The customer level';
            }
            field("Discount"; Rec."Discount")
            {
                Editable = true;
                ApplicationArea = All;
                ToolTip = 'The discount for the customer';
            }
        }
    }
}