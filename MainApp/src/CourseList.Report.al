report 50101 "Course List"
{
    Caption = 'Course List', comment = 'ESP="Listado de cursos"';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutWord;

    dataset
    {
        dataitem(Course; Course)
        {
            column(ReportCaption; ReportCaptionLbl) { }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName()) { }
            column(Filters; Course.TableCaption() + ': ' + CustFilter) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(CourseNo; "No.") { IncludeCaption = true; }
            column(CourseName; "Name") { IncludeCaption = true; }
            dataitem(CourseEdition; "Course Edition")
            {
                DataItemLinkReference = Course;
                DataItemLink = "Course No." = field("No.");

                column(Edition; Edition) { IncludeCaption = true; }
                column(EditionStartDate; "Start Date") { IncludeCaption = true; }
            }
        }
    }

    // requestpage
    // {
    //     AboutTitle = 'Teaching tip title';
    //     AboutText = 'Teaching tip content';
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 {

    //                 }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(processing)
    //         {
    //             action(LayoutName)
    //             {

    //             }
    //         }
    //     }
    // }

    rendering
    {
        layout(LayoutRDLC)
        {
            Type = RDLC;
            LayoutFile = 'src/CourseList.Report.rdl';
        }
        layout(LayoutExcel)
        {
            Type = Excel;
            LayoutFile = 'src/CourseList.Report.xlsx';
        }
        layout(LayoutWord)
        {
            Type = Word;
            LayoutFile = 'src/CourseList.Report.docx';
        }
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        CustFilter := FormatDocument.GetRecordFiltersWithCaptions(Course);
    end;

    var
        ReportCaptionLbl: Label 'Course List', Comment = 'ESP="Listado de cursos"';
        CustFilter: Text;
        CurrReport_PAGENOCaptionLbl: Label 'Page', Comment = 'ESP="Pág."';
}