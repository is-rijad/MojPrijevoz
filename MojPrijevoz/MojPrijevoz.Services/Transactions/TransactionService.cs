using MapsterMapper;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Requests.Transaction;
using MojPrijevoz.Model.Responses.Transaction;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.FileStorage;

namespace MojPrijevoz.Services.Transactions;

public class TransactionService : BaseCrudService<Transaction, TransactionInsertRequest, TransactionInsertRequest, TransactionResponse, BaseSearchObject>, ITransactionService
{
    public TransactionService(MojPrijevozDbContext context, IMapper mapper, AuthorizationService authorizationService, IFileStorageService? fileStorageService = null) : base(context, mapper, authorizationService, fileStorageService)
    {
    }
}