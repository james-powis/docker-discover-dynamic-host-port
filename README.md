## Example of pulling host port from the docker socket api

This is significantly insecure, just because you can does not mean you should... Better design patters are availiable leveraging solutions like etcd, nomad+consul etc.

My specific use case did not lend itself well to leveraging these complex (and technically expensive) solutions, namely ephemeral docker containers triggered through jenkins jcloud plugin. Configuring ports dynamically for use within Robot Framework was the only way for the test environment to be functional while allowing multiple test runs to be ran simultaniously. The security concerns are drastically reduced due to running in a lab and the individual containers live for minutes not hours. 

Seriously do not do this crap in production or in a publicly facing service.


```bash
docker build -t test .
docker run -v /var/run/docker.sock:/var/run/docker.sock -p 1620 -it test /bin/bash
```

Then in the container run the following

```bash
curl -s --unix-socket /var/run/docker.sock http:/v1.24/containers/$(hostname)/json | jq '.NetworkSettings.Ports."1620/tcp"|.[0].HostPort|tonumber'
```
