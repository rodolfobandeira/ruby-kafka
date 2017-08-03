# ruby-kafka
Simple test of queue (producer/consumar) using Ruby and Apache Kafka + Zookeeper

---

1) Install Zookeeper: `sudo apt-get install zookeeper`

2) Downloading Apache Kafka:

`wget http://apache.parentingamerica.com/kafka/0.11.0.0/kafka_2.11-0.11.0.0.tgz`

3) Installing Kafka:

`sudo mkdir /usr/local/kafka`

`sudo tar -xvf kafka_2.11-0.11.0.0.tgz -C /usr/local/kafka/`

4) Special config to make it work on a single node:

`sudo vim /usr/local/kafka/kafka_2.11-0.11.0.0/config/server.properties`

```
port = 9092
advertised.host.name = localhost
```
5) Starting Apache Kafka in background. Notice that you DON'T need sudo.

`nohup /usr/local/kafka/kafka_2.11-0.11.0.0/bin/kafka-server-start.sh /usr/local/kafka/kafka_2.11-0.11.0.0/config/server.properties &`

6) Let's create a iptables simple firewall allowing only localhost to connect to our Zookeeper and Kafka. Remember that the idea of Zookeeper and Kafta is having a distributed queue system where you can spread your queue on multiple machines. (Huge stuff brow); So, since the idea here is just study using one single machine on digital ocean, here is how to block h4ck3rs from internet connecting to your toys. 

`vim iptables.sh`

```
#!/bin/bash

echo "Closing Kafka and Zookeeper ports from external world. Allowing just locally."

iptables -A INPUT -p tcp --dport 2181 -s 127.0.0.0/8 -j ACCEPT
iptables -A INPUT -p tcp --dport 44337 -s 127.0.0.0/8 -j ACCEPT
iptables -A INPUT -p tcp --dport 34232 -s 127.0.0.0/8 -j ACCEPT
iptables -A INPUT -p tcp --dport 9092 -s 127.0.0.0/8 -j ACCEPT
iptables -A INPUT -p tcp --dport 2181 -j DROP
iptables -A INPUT -p tcp --dport 44337 -j DROP
iptables -A INPUT -p tcp --dport 34232 -j DROP
iptables -A INPUT -p tcp --dport 9092 -j DROP
```

Cleaning iptables before starting our rules. Careful if you have previous rules!! You can check the rules with `sudo iptables -L`

`sudo iptables -F`

`sudo ./iptables.sh`

Now testing using ruby:

`gem install ruby-kafka`

`git clone git@github.com:rodolfobandeira/ruby-kafka.git`

`cd ruby-kafka`

`ruby producer.rb` (Repete 3 times)

`ruby consumer.rb` (Yeahh)

```
Hello, World! 617f4877-e34d-4bab-9993-4f95da626549
1

Hello, World! f14e791a-092f-4100-b35d-c51d716e5e57
2

Hello, World! 87c302aa-df8e-41fa-88b5-657148f029d1
3
```


---

**Reference:** 

https://gist.github.com/monkut/07cd1618102cbae8d587811654c92902

https://devops.profitbricks.com/tutorials/install-and-configure-apache-kafka-on-ubuntu-1604-1/

https://stackoverflow.com/questions/35788697/leader-not-available-kafka-in-console-producer

https://github.com/zendesk/ruby-kafka#consuming-messages-from-kafka

https://github.com/rodolfobandeira/ruby-kafka
