const { app } = require('@azure/functions');

app.serviceBusQueue('serviceBusQueueTrigger', {
    connection: 'ServiceBusConnection',
    queueName: '%ServiceBusQueueName%',
    handler: async (message, context) => {
        context.log('JavaScript ServiceBus Queue trigger start processing a message:', message);
        
        // Simulate processing time (30 seconds like the Python version)
        await new Promise(resolve => setTimeout(resolve, 30000));
        
        context.log('JavaScript ServiceBus Queue trigger end processing a message');
    }
});