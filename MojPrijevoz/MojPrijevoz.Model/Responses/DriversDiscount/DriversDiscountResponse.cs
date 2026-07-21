namespace MojPrijevoz.Model.Responses.DriversDiscount;

public class DriversDiscountResponse
{
    public int Id { get; set; }
    public float MinKm { get; set; }
    public float? MaxKm { get; set; }
    public float Discount { get; set; }
}