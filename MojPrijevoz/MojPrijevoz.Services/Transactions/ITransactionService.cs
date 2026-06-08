using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Requests.Transaction;
using MojPrijevoz.Model.Responses.Transaction;
using MojPrijevoz.Services.BaseServices;

namespace MojPrijevoz.Services.Transactions;

public interface ITransactionService : IBaseCRUDService<TransactionInsertRequest, TransactionInsertRequest, TransactionResponse, BaseSearchObject>
{
    
}