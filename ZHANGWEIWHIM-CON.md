I was use elastalert:v.0.2.4 and elastalert-kibana-plugin:7.5.0

Then the elastalert-kibana-plugin the lastest version was just 7.5.0  


Has areadly support the Wechat Work 

## step1.Clone the repository
```bash
git clone https://github.com/zhangweiwhim/elastalert-server.git && cd elastalert-server

```

## step2.Modify the config for u es server
modify all config files that files under config dir  


## step3.Build the image
```bash
make install
```
### hold on few times . u will find below pic

![image](http://github.com/zhangweiwhim/readme_add_pic/raw/master/images/elasalert1.png)


## step4.Run the Docker container

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

## step5. Op on kibana Web 

![image](http://github.com/zhangweiwhim/readme_add_pic/raw/master/images/elastalert2-1.png)

the new rules was created that input format like the files under the elastalert-server/ruels 


![image](http://github.com/zhangweiwhim/readme_add_pic/raw/master/images/elastalert2-2.png)

