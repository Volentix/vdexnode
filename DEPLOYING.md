# vDexNode hardware
## Prerequisites
In order to start a vDexNode, you need a server or computer that satisfies the following parameters:
* Able to operate `24/7` **continuously**
* Has a solid internet connection `> 10 Mbps for Download` and `>5 Mbps for Upload`
* Has a minimum `1 Gb of RAM`
* Has `any CPU`
* Has at least `10 Gb of storage space`
* Ubuntu is a recommended operating system, but the node will work fine on any OS that has Docker software on it.

## AWS
Below you'll find the detailed instruction of how to configure the EC2 AWS instance as a server for vDexNode.

It is assumed that you already have an AWS account and are logged into the management console.

1. Go to `EC2` service
<img width="1255" alt="1" src="https://user-images.githubusercontent.com/2269864/63956139-c4ca0a80-ca3a-11e9-9941-b99a2590e955.png">

2. In the left panel choose the `instances` tab
<img width="1437" alt="2" src="https://user-images.githubusercontent.com/2269864/63956140-c4ca0a80-ca3a-11e9-8d07-c332c1be752f.png">

3. Here is the list of your instances. To run a new one click on `Launch instance`
<img width="1438" alt="3" src="https://user-images.githubusercontent.com/2269864/63956142-c562a100-ca3a-11e9-8306-74d4e23c4bed.png">

4. In the list of available OS, choose the `Ubuntu Server 18.04` by clicking the `Select` button.
<img width="1437" alt="4" src="https://user-images.githubusercontent.com/2269864/63956143-c562a100-ca3a-11e9-9528-930219ccf869.png">

5. In the list of instance types, you can choose whatever you want, but remember, your instance should have at least 1 Gb of RAM. In this example I chose `t2.micro`. Then, click `Next: Configure Instance Details` button.
<img width="1428" alt="5" src="https://user-images.githubusercontent.com/2269864/63956145-c562a100-ca3a-11e9-9ab1-60d79f62100c.png">

6. You can leave this parameters by default. Don't change anything if you don't know what you're doing. Then click on `Next: Add Storage` button.
<img width="1430" alt="6" src="https://user-images.githubusercontent.com/2269864/63956146-c562a100-ca3a-11e9-871c-dc810a1fd5b4.png">

7. Add some storage space. Minimum is 10 Gb. Then click on `Next: Add Tags` button.
<img width="1431" alt="7" src="https://user-images.githubusercontent.com/2269864/63956147-c562a100-ca3a-11e9-876b-2fd64fe3c804.png">

8. You don't need to do anything here, so just click on `Next: Configure Security Group` button.
<img width="1426" alt="8" src="https://user-images.githubusercontent.com/2269864/63956148-c562a100-ca3a-11e9-84f6-d68d30f31f86.png">

9. Choose `Create a new security group` and insert a name for the new security group. The `SSH` rule should be already configured by default. If not, click `Add Rule` button and add the rule as on screenshot. Also, add the rule to allow All the traffic with all the ports from any resource as you see on screenshot.

	>This temporary solution is necessary until the ports and type of traffic necessary for the operation of the nodes are precisely determined. Documentation will be updated.

	After all the rules have been added, just click on `Review and Launch` button.

	<img width="1422" alt="9" src="https://user-images.githubusercontent.com/2269864/63956150-c5fb3780-ca3a-11e9-906b-9e36ffa55d94.png">

10. On this page you can review your settings and change anything if you want. Then click on `Launch` button.
<img width="1422" alt="10" src="https://user-images.githubusercontent.com/2269864/63956151-c5fb3780-ca3a-11e9-9a83-fd2b246a928d.png">

11. In the window that appears, you will be asked to select an existing one or create a new server access key.

	* Choose `Create a new key pair`.
	* Insert the key name.
	* Click on `Download Key Pair` button.
	* Go to step `12`

	<img width="871" alt="11" src="https://user-images.githubusercontent.com/2269864/63956152-c5fb3780-ca3a-11e9-8dee-cfaaea22120b.png">

12. Download button will open a window for saving your new key to the computer. You can save it anywhere, but we recommend that you save it in a hidden `.ssh` folder in your home directory.

	>Be sure to save the key and not lose it. Otherwise, it cannot be restored, since Amazon does not store your keys on its servers.

	Only after you are sure that you saved the key, click the `Launch Instances` button that is shown at number `4` in the screenshot of step `11`
	<img width="857" alt="12" src="https://user-images.githubusercontent.com/2269864/63956153-c5fb3780-ca3a-11e9-9a50-638fab113b7e.png">

13. Your instance are now launching. By clicking on the link under red arrow, you can go to instances page.
<img width="1429" alt="13" src="https://user-images.githubusercontent.com/2269864/63956154-c5fb3780-ca3a-11e9-82ec-3a8d0e464db9.png">

14. Here is your instance in the list of instances. In the red square you will see a public addresses you can connect to your server with.
	> Note that state of your node is `pending`. You'll have to wait a couple of minutes until it starts

	<img width="1435" alt="14" src="https://user-images.githubusercontent.com/2269864/63956155-c5fb3780-ca3a-11e9-810d-01bab4ba5474.png">

15. When the state changes to `running`, you can connect to the server.
<img width="1224" alt="15" src="https://user-images.githubusercontent.com/2269864/63956156-c693ce00-ca3a-11e9-84aa-1b193dae51fb.png">

16. Before using the key, you have to change the permissions of it. Use the command `sudo chmod 600 /path/to/key/vDexNode.pem`
<img width="506" alt="16" src="https://user-images.githubusercontent.com/2269864/63956157-c693ce00-ca3a-11e9-84c2-eea3f3a0dab7.png">

17. The permissions of the key should looks like on the screenshot:
`-rw-------`
<img width="512" alt="17" src="https://user-images.githubusercontent.com/2269864/63956159-c693ce00-ca3a-11e9-9406-894d9640737c.png">

18. So now you can try to connect to your AWS server via SSH.
```bash
# you can use your public DNS from the screenshot on step 14
ssh -i /path/to/key/vDexNode.pem ubuntu@ec2-35-182-228-117.ca-central-1.compute.amazonaws.com
# or you can use public ip instead
ssh -i /path/to/key/vDexNode.pem ubuntu@35.182.228.117
```
It will ask you to enter `yes` into terminal to allow the connection.
<img width="1074" alt="18" src="https://user-images.githubusercontent.com/2269864/63956160-c693ce00-ca3a-11e9-9b58-67c4c229da17.png">

19. Finally we are on our machine.
<img width="753" alt="19" src="https://user-images.githubusercontent.com/2269864/63956161-c693ce00-ca3a-11e9-93f9-e1c8d1b6224d.png">

Now you can go to the README file and proceed to install [vDexNode Software](README.md).