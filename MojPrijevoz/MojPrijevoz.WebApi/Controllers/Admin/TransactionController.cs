using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Admin;

namespace MojPrijevoz.WebApi.Controllers.Admin;

[ApiController]
[Authorize(Roles = "1")]
[Route("api/admin/[controller]")]
public class TransactionController : ControllerBase
{
    private readonly AdminTransactionService _transactionService;

    public TransactionController(AdminTransactionService transactionService)
    {
        _transactionService = transactionService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] AdminTransactionSearchObject searchObject)
    {
        return Ok(await _transactionService.GetAsync(searchObject));
    }

    [HttpGet("users")]
    public async Task<IActionResult> Get(AdminUserSearchObject searchObject)
    {
        return Ok(await _transactionService.GetUsersAsync(searchObject));
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] AdminTransactionSearchObject searchObject)
    {
        return Ok(await _transactionService.UpdateTransactionsAsync(searchObject));
    }
}