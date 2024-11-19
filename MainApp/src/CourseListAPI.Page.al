page 50108 "CourseListAPI"
{
    PageType = API;
    Caption = 'CourseListAPI', Locked = true;
    APIPublisher = 'clipplatform';
    APIGroup = 'communication';
    APIVersion = 'v1.0';
    EntityName = 'course';
    EntitySetName = 'courses';
    SourceTable = Course;
    DelayedInsert = true;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(RepeaterControl)
            {
                field(no; Rec."No.") { NotBlank = true; }
                field(name; Rec.Name) { NotBlank = true; }
                field(contentDescription; Rec."Content Description") { Editable = false; }
                field(courseType; Rec.Type) { Editable = false; }
            }
        }
    }
}