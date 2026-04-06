using Microsoft.AspNetCore.Mvc;
using MojPrijevoz.Model.Requests.DriversDiscount;
using MojPrijevoz.Model.SearchObjects;
using MojPrijevoz.Services.DriversDiscount;

namespace MojPrijevoz.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DriversDiscountController : ControllerBase {
    private readonly DriversDiscountService _driversDiscountService;

    public DriversDiscountController(DriversDiscountService driversDiscountService) {
        _driversDiscountService = driversDiscountService;
    }
    [HttpGet]
    public async Task<IActionResult> Get([FromQuery] DriversDiscountSearchObject searchObject) {
        return Ok(await _driversDiscountService.GetAsync(searchObject));
    }
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id) {
        return Ok(await _driversDiscountService.GetByIdAsync(id));
    }
    [HttpPost]
    public async Task<IActionResult> Post(DriversDiscountUpsertRequest request) {
        return Ok(await _driversDiscountService.InsertWithTransactionAsync(request));
    }
    [HttpPut("{id}")]
    public async Task<IActionResult> Put(int id, DriversDiscountUpsertRequest request) {
        return Ok(await _driversDiscountService.UpdateAsync(id, request));
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id) {
        await _driversDiscountService.DeleteAsync(id);
        return Ok();
    }
}