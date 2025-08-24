import { app, InvocationContext } from '@azure/functions';

app.serviceBusQueue('serviceBusQueueTrigger', {
    connection: 'ServiceBusConnection',
    queueName: '%ServiceBusQueueName%',
    handler: async (message: unknown, context: InvocationContext): Promise<void> => {
        context.log('TypeScript ServiceBus Queue trigger start processing a message:', typeof message === 'string' ? message : JSON.stringify(message));
        
        // Simulate processing time (30 seconds like the Python version)
        await new Promise<void>(resolve => setTimeout(resolve, 30000));
        
        context.log('TypeScript ServiceBus Queue trigger end processing a message');
    }
});