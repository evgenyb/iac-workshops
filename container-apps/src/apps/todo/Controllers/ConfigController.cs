using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace todo.Controllers;

[ApiController]
[Route("[controller]")]
public class ConfigController : ControllerBase
{
    private readonly ILogger<ConfigController> _logger;

    public ConfigController(ILogger<ConfigController> logger)
    {
        _logger = logger;
    }

    [HttpGet]
    public IActionResult Get()
    {
        var clientIp = GetClientIp();
        var serverIp = GetServerIp();
        var logMessage = $"[todo]: ClientIP = {clientIp}, ServerIp = {serverIp}";
        _logger.LogInformation(logMessage);
        return Ok(logMessage);
    }

    private string? GetClientIp()
    {
        return HttpContext.Connection.RemoteIpAddress?.ToString();
    }

    private string? GetServerIp()
    {
        var feature = HttpContext.Features.Get<IHttpConnectionFeature>();
        return feature?.LocalIpAddress?.ToString();
    }
}
