reportextension 50100 "Standard Sales - Invoice" extends "Standard Sales - Invoice"
{
    dataset
    {
        add(Line)
        {
            column(Course_Edition; "Course Edition") { }
        }
    }

    requestpage
    {
        layout
        {
            addfirst(Options)
            {
                field(Algo; 'Algo fijo') { }
            }
        }
    }

    rendering
    {
        layout(MyRDLCLayout)
        {
            Type = RDLC;
            LayoutFile = 'src/StandardSalesInvoice.ReportExtension.rdl';
        }
    }
}