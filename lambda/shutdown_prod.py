import boto3
import logging
import json

ec2 = boto3.resource('ec2')

def lambda_handler(event, context):

    filters = [{
            'Name': 'tag:CostSaving', 
            'Values': ['auto_shutdown'] 
        },
        {
            'Name': 'instance-state-name', 
            'Values': ['running']
        }
    ]
    
    instances = ec2.instances.filter(Filters=filters)
    
    
    
    
    
        
    runningInstances = [instance.id for instance in instances]
    
        
    if len(runningInstances) > 0:
        try:
        	shuttingDown = ec2.instances.filter(InstanceIds=runningInstances).stop()
    	  
    	except Exception as e:
            print(e)
            raise e
        return shuttingDown
        print (json(shuttingDown,indent=4))
        
    
    

