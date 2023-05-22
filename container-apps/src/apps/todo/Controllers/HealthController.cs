using Microsoft.AspNetCore.Mvc;

namespace todo.Controllers;

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