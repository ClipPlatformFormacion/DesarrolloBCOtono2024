namespace ClipPlatform.Course.Setup;

using Microsoft.Foundation.NoSeries;

table 50101 "Courses Setup"
{
    CaptionML = ENU = 'Courses Setup', ESP = 'Conf. cursos';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Course Nos."; Code[20])
        {
            CaptionML = ENU = 'Course Nos.', ESP = 'Nº serie curso';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}

