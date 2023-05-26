# Payment System Task

### Configure application
1. Install Ruby&Rails [Manual](https://gorails.com/setup/ubuntu/22.04)
2. Clone repository
3. Execute ``bundle install`` to install required gems
4. Create postgresql user **payment_system_task** with password **payment_system_task** (for development and testing) or override Env variables for production:
   ````
   host: <%= ENV['PAYMENT_SYSTEM_TASK_DATABASE_HOST']     || 'localhost' %>
   port: <%= ENV['PAYMENT_SYSTEM_TASK_DATABASE_PORT']     || '5432' %>
   username: <%= ENV['PAYMENT_SYSTEM_TASK_DATABASE_USERNAME'] || 'payment_system_task' %>
   password: <%= ENV['PAYMENT_SYSTEM_TASK_DATABASE_PASSWORD'] || 'payment_system_task' %>
   ````
5. Create, migrate, seed databases:
   ````
   rails db:create db:migrate db:seed
   ```` 
### Run application
````
rails s
````

### Run Jobs
For development:
````
whenever --update-crontab --set environment='development'
````

For production:
````
whenever --update-crontab
````

Jobs log can be found at ``log/cron.log``.

### Execute tasks

1. import users
    ````
     rake import:users filename=<filename>.xml
    ````

    Example of users xml file can be found at ``spec/fixtures/users.xml``

### Execute tests
````
rspec
````

### Execute linters
````
rubocop
````

### API

1. Create Transactions

   POST   **/api/transactions**

   **Request example:**
   ```json
   {
      "transaction":{
         "amount":100,
         "status":"approved",
         "customer_email":"my@secret.email",
         "customer_phone":"myPhone",
         "type":"Authorize",
         "user_id":"c264b98c-4735-4287-8a85-9748aa7d3caf"
      }
   }
   ```
   
   You are expected to fill following request headers:
   ```
   Accept:"application/json"
   Content-Type:"application/json"
   ```
   
   To pass **Basic Auth** use existing Merchant **id** as username and his **email** like a password.
   **user_id** in request and Merchant **id** from Basic Auth should be the same. 
