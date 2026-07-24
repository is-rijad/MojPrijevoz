using MojPrijevoz.Model.BaseModels.Admin;

namespace MojPrijevoz.Model.SearchObjects.Admin;

public class AdminUserSearchObject : AdminStringSearchObject
{
    public bool? OnlyWithBankAccountNumber { get; set; }
}