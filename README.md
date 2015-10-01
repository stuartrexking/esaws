# Event Store cluster on AWS

 * [Description](#description)
 * [Dependencies](#dependencies)
 * [Setup](#setup)
 
### Description

The Vagrantfile will create an Ubuntu Trusty instance where you can drive the cluster build from.

### Dependencies

1. Install [Vagrant](https://www.vagrantup.com/)
1. Create AWS Key Id and Secret Access Key as per the [AWS setup guide](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html#cli-signup). Ensure the keys have policy permissions to create resources, e.g. AdministratorAccess. 

### Setup

```
git clone https://github.com/stuartrexking/esaws
cd esaws
AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY bash -c 'vagrant up'
```

I'm not sure how to run the command on Windows. At a guess

```
vagrant up /C "set AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID && set AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY"
```

This will

1. Download a vanilla ubuntu/trusty image
1. Install Git
1. Install AWS CLI
1. Install Terraform
1. Clone this repo
1. Configure Terraform with the variables required to run the cluster build

Once the Vagrant VM is running

```
vagrant ssh
```

Then you can build the infrastructure with 

```
vagrant@vagrant-ubuntu-trusty-64:~$ cd esaws 
vagrant@vagrant-ubuntu-trusty-64:~$ make 
```

This will

1. Create a VPC in the AWS eu-west-1 region
1. Create a public and a private subnet within that VPC
1. Create a NAT, a bastion and an Nginx reverse proxy load balancer in the public subnet
1. Create a three node Event Store cluster in the private subnet
1. A Consul cluster between the Event Store cluster and the Nginx cluster with all the services registered and discoverable via DNS

To see all the resources that have been created

```
vagrant@vagrant-ubuntu-trusty-64:~$ make show
```

To test the cluster using curl

```
vagrant@vagrant-ubuntu-trusty-64:~$ make show

#Look for the nginx load balancer public_ip. Your value will be different to the example.
...
module.nginx.aws_instance.nginx:
  id = i-7132d8c9
  ami = ami-3de9c34a
  associate_public_ip_address = true
  availability_zone = eu-west-1b
  ebs_block_device.# = 0
  ebs_optimized = false
  ephemeral_block_device.# = 0
  instance_type = t1.micro
  key_name = esaws
  monitoring = false
  private_dns = ip-10-0-0-9.eu-west-1.compute.internal
  private_ip = 10.0.0.9
  public_dns = ec2-52-19-239-1.eu-west-1.compute.amazonaws.com
  public_ip = 52.19.239.1
  root_block_device.# = 1
  root_block_device.0.delete_on_termination = true
  root_block_device.0.iops = 24
  root_block_device.0.volume_s
...

vagrant@vagrant-ubuntu-trusty-64:~$ echo '[{"eventId":"fbf4a1a1-b4a3-4dfe-a01f-ec52c34e16e4","eventType":"event-type","data":{"a":"1"}}]' >> event.json
vagrant@vagrant-ubuntu-trusty-64:~$ curl -i -d @event.json "http://52.19.239.1/streams/newstream" -H "Content-Type:application/vnd.eventstore.events+json"
HTTP/1.1 201 Created
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-Forwarded-Host, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Location: http://172.20.20.11:2112/streams/newstream/1
Server: Mono-HTTPAPI/1.0
Date: Thu, 17 Sep 2015 10:42:32 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 0
Keep-Alive: timeout=15,max=100%
```

To then read from the stream as xml

```
vagrant@vagrant-ubuntu-trusty-64:~$ curl -i -H "Accept:application/atom+xml" "http://52.19.239.1/streams/newstream"
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-Forwarded-Host, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "1;-1296467268"
Content-Type: application/atom+xml; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 17 Sep 2015 10:46:35 GMT
Content-Length: 1299
Keep-Alive: timeout=15,max=100

<?xml version="1.0" encoding="utf-8"?><feed xmlns="http://www.w3.org/2005/Atom"><title>Event stream 'newstream'</title><id>http://172.20.20.10:2113/streams/newstream</id><updated>2015-09-17T10:42:32.630844Z</updated><author><name>EventStore</name></author><link href="http://172.20.20.10:2113/streams/newstream" rel="self" /><link href="http://172.20.20.10:2113/streams/newstream/head/backward/20" rel="first" /><link href="http://172.20.20.10:2113/streams/newstream/2/forward/20" rel="previous" /><link href="http://172.20.20.10:2113/streams/newstream/metadata" rel="metadata" /><entry><title>1@newstream</title><id>http://172.20.20.10:2113/streams/newstream/1</id><updated>2015-09-17T10:42:32.630844Z</updated><author><name>EventStore</name></author><summary>event-type</summary><link href="http://172.20.20.10:2113/streams/newstream/1" rel="edit" /><link href="http://172.20.20.10:2113/streams/newstream/1" rel="alternate" /></entry><entry><title>0@newstream</title><id>http://172.20.20.10:2113/streams/newstream/0</id><updated>2015-09-16T10:01:14.792879Z</updated><author><name>EventStore</name></author><summary>event-type</summary><link href="http://172.20.20.10:2113/streams/newstream/0" rel="edit" /><link href="http://172.20.20.10:2113/streams/newstream/0" rel="alternate" /></entry></feed>
```

or json

```
vagrant@vagrant-ubuntu-trusty-64:~$ curl -i http://52.19.239.1/streams/newstream/0 -H "Accept: application/json"
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-Forwarded-Host, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=31536000, public
Vary: Accept
Content-Type: application/json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 17 Sep 2015 10:48:36 GMT
Content-Length: 14
Keep-Alive: timeout=15,max=100

{
  "a": "1"
}
```

The commands above could be done from any machine with internet access.

To destroy the cluster

```
vagrant@vagrant-ubuntu-trusty-64:~$ make destroy
```