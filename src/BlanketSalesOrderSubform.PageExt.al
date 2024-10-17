pageextension 50104 "Blanket Sales Order Subform" extends "Blanket Sales Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Course Edition"; Rec."Course Edition")
            {
                ApplicationArea = All;
            }
        }
    }
}