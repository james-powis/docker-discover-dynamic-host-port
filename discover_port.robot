*** Settings ***

Library  BuiltIn
LIbrary  OperatingSystem
Library  String
Library  Process


*** Variables ***

${default_port}  1620
${host_ip}  192.168.0.211

*** Test Cases ***


Setup Listener and Receive Message
    ${ext_port} =  Run Keyword  Get Host Port

    #Start Process  /bin/bash  -c  sleep 5 && echo '<14>foo' | nc -v -u ${host_ip} ${ext_port}
    Start Process  /bin/bash  -c  sleep 5 && echo "<14>foo" >/dev/udp/${host_ip}/${ext_port}
    ${result} =  Run  ./syslog_server.py ${default_port}
    Log to Console  ${result}

*** Keywords ***

In Docker Container
    [Documentation]  Checkl if we are in a docker container
    ...              based on hostname being a 12 digit hexadecimal string

    ${hostname}=  Run  hostname
    Should Match Regexp  ${hostname}  ^[0-9a-f]{12}$

Get Host Port
    [Documentation]  Returns the default port unless running in a docker container

    ${in_container}=  Run Keyword and Ignore Error  In Docker Container
    ${ext_port}=  Run Keyword If  "${in_container[0]}" == "PASS"  Lookup External Docker Port
    ...       ELSE  Set Variable  ${default_port}
    [Return]  ${ext_port}

Lookup External Docker Port
    [Documentation]  Calls the mounted docker.sock api to lookup the specific port
    ${ext_port}=  Run  curl -s --unix-socket /var/run/docker.sock http:/v1.24/containers/$(hostname)/json | jq '.NetworkSettings.Ports."${default_port}/udp"|.[0].HostPort|tonumber'
    [Return]  ${ext_port}
