using Microsoft.AspNetCore.Mvc;

namespace api_a.Controllers;

[ApiController]
[Route("[controller]")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        return Ok("ok");
    }    
}