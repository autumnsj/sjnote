

## nginx 

## 1.安装

```shell
apt install nginx
```

## 2.配置

```nginx
server {
   listen 80;
   server_name wl123.shipro.ltd;
   client_max_body_size 1024m;
   charset utf-8;
   underscores_in_headers on;
   location / {
       root   /home/project/wl123/web;
       try_files $uri $uri/ /index.html;
       index  index.html index.htm;
   }
   location /prod-api/ {
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      	   proxy_redirect off;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_pass http://localhost:9005/;
   }
   error_page   500 502 503 504  /50x.html;
   location = /50x.html {
       root   html;
   }
}

```

## 3.配置



## Nginx on Ubuntu 20

1. 

2. ```bash
   sudo apt update
   sudo apt install snapd
   ```

3. Install Certbot

   Run this command on the command line on the machine to install Certbot.

   ```
   sudo snap install --classic certbot
   ```

4. Prepare the Certbot command

   Execute the following instruction on the command line on the machine to ensure that the `certbot` command can be run.

   ```
   sudo ln -s /snap/bin/certbot /usr/bin/certbot
   ```

5. Choose how you'd like to run Certbot

   ### Either get and install your certificates...

   Run this command to get a certificate and have Certbot edit your nginx configuration automatically to serve it, turning on HTTPS access in a single step.

   ```
   sudo certbot --nginx
   ```

   ### Or, just get a certificate

   If you're feeling more conservative and would like to make the changes to your nginx configuration by hand, run this command.

   ```
   sudo certbot certonly --nginx
   ```

6. Test automatic renewal

   The Certbot packages on your system come with a cron job or systemd timer that will renew your certificates automatically before they expire. You will not need to run Certbot again, unless you change your configuration. You can test automatic renewal for your certificates by running this command:

   ```
   sudo certbot renew --dry-run
   ```

   The command to renew certbot is installed in one of the following locations:

   - `/etc/crontab/`
   - `/etc/cron.*/*`
   - `systemctl list-timers`

7. Confirm that Certbot worked

   To confirm that your site is set up properly, visit `https://yourwebsite.com/` in your browser and look for the lock icon in the URL bar.
