page 50100 "Course List"
{
    CaptionML = ENU = 'Courses', ESP = 'Cursos';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Course;
    Editable = false;
    CardPageId = "Course Card";

    layout
    {
        area(Content)
        {
            repeater(RepeaterControl)
            {
                field("No."; Rec."No.") { }
                field(Name; Rec.Name) { }
                field("Duration (hours)"; Rec."Duration (hours)") { }
                field("Language Code"; Rec."Language Code") { }
                field(Type; Rec.Type) { }
            }
        }
        area(FactBoxes)
        {
            part(CourseEditions; "Course Editions Factbox")
            {
                SubPageLink = "Course No." = field("No.");
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(Editions)
            {
                CaptionML = ENU = 'Editions', ESP = 'Ediciones';
                RunObject = page "Course Editions";
                RunPageLink = "Course No." = field("No.");
                Image = ListPage;
            }
        }
    }
}