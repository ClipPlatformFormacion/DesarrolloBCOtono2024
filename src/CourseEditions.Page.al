page 50104 "Course Editions"
{
    CaptionML = ENU = 'Course Editions', ESP = 'Ediciones curso';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Course Edition";

    layout
    {
        area(Content)
        {
            repeater(RepeaterControl)
            {
                field("Course No."; Rec."Course No.")
                {
                    Visible = false;
                }
                field(Edition; Rec.Edition) { }
                field("Start Date"; Rec."Start Date") { }
                field("Max. Students"; Rec."Max. Students") { }
            }
        }
    }
}