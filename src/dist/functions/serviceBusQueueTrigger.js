"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const functions_1 = require("@azure/functions");
functions_1.app.serviceBusQueue('serviceBusQueueTrigger', {
    connection: 'ServiceBusConnection',
    queueName: '%ServiceBusQueueName%',
    handler: async (message, context) => {
        context.log('TypeScript ServiceBus Queue trigger start processing a message:', message);
        // Simulate processing time (30 seconds like the Python version)
        await new Promise(resolve => setTimeout(resolve, 30000));
        context.log('TypeScript ServiceBus Queue trigger end processing a message');
    }
});
