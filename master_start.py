import boto3
import os
import sys
import subprocess

ASG_NAME = "jmeter-slave-ASG"

JMETER_PATH = "apache-jmeter-5.2.1/bin/jmeter"
JMETER_SCRIPT = "script.jmx"

class Instance:
	def __init__(self, botoClient, instanceId):
		self.botoClient = botoClient
		self.instanceId = instanceId

	def getPrivateIP(self):
		response = self.botoClient.describe_instances(InstanceIds=[self.instanceId])
		reservations = response['Reservations']
		if len(reservations) != 1:
			raise Exception("Can't find reservations in instance: " + self.instanceId)

		instances = reservations[0]['Instances']
		if len(instances) != 1:  
			raise Exception("Can't find instance " + self.instanceId)

		return instances[0]['PrivateIpAddress']

class AutoscalingGroup:
	def __init__(self, autoscalingBotoClient, ec2BotoClient, name):
		self.name = name
		self.botoClient = autoscalingBotoClient
		self.ec2Client = ec2BotoClient

	def getInstances(self):
		response = self.botoClient.describe_auto_scaling_groups(AutoScalingGroupNames=[self.name], MaxRecords=1)
		asgs = response['AutoScalingGroups']

		if len(asgs) != 1:
			raise Exception("Can't find autoscaling group: " + self.name)

		asg = asgs[0];
		instances = []

		for instance in asg['Instances']:
			instances.append(Instance(self.ec2Client, instance['InstanceId']))

		return instances


autoscalingGroup = AutoscalingGroup(boto3.client(
	'autoscaling', region_name='us-east-1'), boto3.client('ec2', region_name='us-east-1'), ASG_NAME)
instances = autoscalingGroup.getInstances()
absoluteJmeterPath = os.path.join(sys.path[0], JMETER_PATH)

command = [absoluteJmeterPath, '-Jserver.rmi.ssl.disable=true',
           '-Jserver.rmi.port=1664', '-n', '-t', JMETER_SCRIPT,
           '-f', '-l', '/jmeter-master/report.txt', '-e', '-o', '/var/www/html/',
		   '-L', 'jmeter.util=DEBUG',  '-R']
command[-1] += ','.join([instance.getPrivateIP() for instance in instances])
subprocess.call(command)