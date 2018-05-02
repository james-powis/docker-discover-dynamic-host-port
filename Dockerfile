FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl jq python && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py

ADD requirements.txt /requirements.txt

ADD discover_port.robot /discover_port.robot
ADD syslog_server.py /syslog_server.py

RUN pip install -r /requirements.txt

EXPOSE 1620
