using System;
using System.Threading.Tasks;
using Azure.Messaging.ServiceBus;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace ServiceBusQueueProcessor;

public class ServiceBusQueueTrigger
{
    private readonly ILogger<ServiceBusQueueTrigger> _logger;

    public ServiceBusQueueTrigger(ILogger<ServiceBusQueueTrigger> logger)
    {
        _logger = logger;
    }

    [Function(nameof(ServiceBusQueueTrigger))]
    public async Task Run(
        [ServiceBusTrigger("%ServiceBusQueueName%", Connection = "ServiceBusConnection")]
        ServiceBusReceivedMessage message,
        ServiceBusMessageActions messageActions)
    {
        _logger.LogInformation(".NET ServiceBus Queue trigger start processing a message: {body}",
            message.Body.ToString());
        
        // Simulate processing time like the Python version
        await Task.Delay(TimeSpan.FromSeconds(30));
        
        _logger.LogInformation(".NET ServiceBus Queue trigger end processing a message");
        
        // Complete the message
        await messageActions.CompleteMessageAsync(message);
    }
}