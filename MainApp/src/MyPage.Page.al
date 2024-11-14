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
        }
    }
}