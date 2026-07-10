using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.Admin.Transaction;
using MojPrijevoz.Model.SearchObjects.Admin;
using MojPrijevoz.Services.Admin;

namespace MojPrijevoz.WebApi.Controllers.Admin;
[ApiController]
[Authorize(Roles = "1")]
[Route("api/admin/[controller]")]
    public class TransactionController : ControllerBase {
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
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id) {
            return Ok(await _transactionService.GetByIdAsync(id));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id) {
            return Ok(await _transactionService.UpdateAsync(id, new AdminTransactionUpdateRequest()));
        }
}

