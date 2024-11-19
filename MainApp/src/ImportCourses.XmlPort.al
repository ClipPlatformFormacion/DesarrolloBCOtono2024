xmlport 50103 "Import Courses"
{
    Direction = Import;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement(Course; Course)
            {
                AutoUpdate = true;
                // AutoReplace = true;
                fieldelement(courseNo; Course."No.")
                {
                }
                fieldelement(courseName; Course.Name)
                {
                }
                fieldelement(coursePrice; Course."Price")
                {
                }
                fieldelement(courseType; Course."Type")
                {
                }
                textelement(VATPercentage) { }

                trigger OnBeforeInsertRecord()
                begin
                    Course."Content Description" := Course.Name;
                    Course."VAT Prod. Posting Group" := 'IVA' + VATPercentage;
                end;

                trigger OnBeforeModifyRecord()
                begin
                    Course."Content Description" := Course.Name;
                    Course."VAT Prod. Posting Group" := 'IVA' + VATPercentage;
                end;
            }
        }
    }
}