query 50100 "Simple Item Query"
{
    elements
    {
        dataitem(Item; Item)
        {
            DataItemTableFilter = "Replenishment System" = const(Purchase);

            column(No; "No.") { }
            column(Description; Description) { }
            column(Base_Unit_of_Measure; "Base Unit of Measure") { }
            column(Unit_Cost; "Unit Cost") { }
            filter(Assembly_BOM; "Assembly BOM")
            {

            }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "No." = Item."Vendor No.";
                SqlJoinType = InnerJoin;
                column(VendorName; Name) { }
                column(VendorCity; City) { }
            }
        }
    }
}