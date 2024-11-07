enum 50101 "Customer Level" implements ICustomerLevel
{
    Extensible = true;

    value(0; " ")
    {
        Implementation = ICustomerLevel = "Blank Customer Level";
    }
    value(1; "Bronze")
    {
        Implementation = ICustomerLevel = "Bronze Customer Level";
    }
    value(2; "Silver")
    {
        Implementation = ICustomerLevel = "Silver Customer Level";
    }
}