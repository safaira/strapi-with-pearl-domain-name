# strapi deployment with PM2 on EC2 using Terraform and Github Action #

* Configure Infrastructure using Terraform:
VPC
EC2
* Creat Github Action Workflow to which create Infrastructure by installing Terraform on the server.
  
**Troubleshooting:**
strapi repo : https://github.com/safaira/strapi.git

when I run "npm start" it gives error:

**error:**
Middleware "strapi::session": App keys are required. Please set app.keys in config/server.js (ex: keys: ['myKeyA', 'myKeyB']) Error: Middleware "strapi::session": App keys are required. Please set 
app.keys in config/server.js (ex: keys: ['myKeyA', 'myKeyB']) at instantiateMiddleware (/srv/strapi/node_modules/@strapi/strapi/dist/services/server/middleware.js:13:13) at Module.resolveMiddlewares 
(/srv/strapi/node_modules/@strapi/strapi/dist/services/server/middleware.js:43:18) at registerApplicationMiddlewares (/srv/strapi/node_modules/@strapi/strapi/dist/services/server/register-middlewares.js:44:40) 
at async Object.initMiddlewares (/srv/strapi/node_modules/@strapi/strapi/dist/services/server/index.js:69:7) at async Strapi.bootstrap (/srv/strapi/node_modules/@strapi/strapi/dist/Strapi.js:417:5) at async 
Strapi.load (/srv/strapi/node_modules/@strapi/strapi/dist/Strapi.js:426:5) at async Strapi.start (/srv/strapi/node_modules/@strapi/strapi/dist/Strapi.js:216:9)

**Solution:**
The env file is auto-generated when using the CLI tool not cloning it down. (you want to use the CLI tool to create your project). The user here had cloned down their own repo meaning the .env would not exist as it’s not to be committed to github.
Could be explained in the documentation indeed, feel free to make a PR here GitHub - strapi/documentation: Strapi Documentation 165 and add some :slight_smile:
Should also be explained some information regarding .env and the environmental variables in our documentation.
BY **Eventyret
Strapi Solutions Engineer**




