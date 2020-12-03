## step1.Clone the repository
```bash
git clone https://github.com/zhangweiwhim/elastalert-server.git && cd elastalert-server

```

## step2.Build the image
```bash
make install
```
### hold on few times . u will find belw pic

![image](http://github.com/zhangweiwhim/readme_add_pic/raw/master/images/elasalert1.png)


## step3.Run the Docker container

```bash
docker run -d -p 3030:3030 -p 3333:3333 \
    -v `pwd`/config/elastalert.yaml:/opt/elastalert/config.yaml \
    -v `pwd`/config/elastalert-test.yaml:/opt/elastalert/config-test.yaml \
    -v `pwd`/config/config.json:/opt/elastalert-server/config/config.json \
    -v `pwd`/rules:/opt/elastalert/rules \
    -v `pwd`/rule_templates:/opt/elastalert/rule_templates \
    -v `pwd`/smtpAuth:/opt/elastalert/smtpAuth \
    --net="host" \
    --name elastalert zhangweiwhim/elastalert-server:latest

```

### after the contaniner was started

## step4. Op on kibana Web 

![image](http://github.com/zhangweiwhim/readme_add_pic/raw/master/images/elastalert2-1.png)
![image](http://github.com/zhangweiwhim/readme_add_pic/raw/master/images/elastalert2-2.png)

