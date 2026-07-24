namespace MojPrijevoz.Services.Helpers;

public static class MonthHelper
{
    private static Dictionary<int, string> _months = new Dictionary<int, string>()
    {
        { 0, "Januar" }, 
        { 1, "Februar" },  
        { 2, "Mart" },   
        { 3, "April" },  
        { 4, "Maj" },  
        { 5, "Juni" },   
        { 6, "Juli" },   
        { 7, "August" },  
        { 8, "Septembar" },    
        { 9, "Oktobar" }, 
        { 10, "Novembar" }, 
        { 11, "Decembar" } 
    };
    public static string GetMonth(int index)
    {
        return _months[index];
    }
}