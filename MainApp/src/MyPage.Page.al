page 50107 "My Page"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;


    actions
    {
        area(Processing)
        {
            action(ExecuteXML)
            {
                RunObject = xmlport "Sales Order Export";
                Image = Export;
            }
            action(ExecuteXMLcsv)
            {
                RunObject = xmlport "Sales Order Export - csv";
                Image = Export;
            }
            action(ExecuteXMLTextoFijo)
            {
                RunObject = xmlport "Sales Order Export - TextoFijo";
                Image = Export;
            }
            action(ExecuteQuery)
            {
                RunObject = query "Simple Item Query";
                Image = NextRecord;
            }
        }
    }
}