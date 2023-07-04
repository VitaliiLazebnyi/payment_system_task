# Payment System Task

## Native Application Usage

### Configure application
1. Install Ruby&Rails [Manual](https://gorails.com/setup/ubuntu/22.04)
2. Clone repository
3. Execute ``bundle install`` to install required gems
4. Create postgresql user **payment_system_task** with password **payment_system_task** (for development and testing) or override Env variables for production:
    ```
    host: <%= ENV['PAYMENT_SYSTEM_TASK_DATABASE_HOST']     || 'localhost' %>
    port: <%= ENV['PAYMENT_SYSTEM_TASK_DATABASE_PORT']     || '5432' %>
    username: <%= ENV['PAYMENT_SYSTEM_TASK_DATABASE_USERNAME'] || 'payment_system_task' %>
    password: <%= ENV['PAYMENT_SYSTEM_TASK_DATABASE_PASSWORD'] || 'payment_system_task' %>
    ```
5. Create, migrate, seed databases:
    ```
    rails db:create db:migrate db:seed
    ```

### Run application
```
rails s
```

### Run Jobs
For development:
```
whenever --update-crontab --set environment='development'
```

For production:
```
whenever(--update - crontab)
```

Jobs log can be found at ``log/cron.log``.

### Execute tasks

import users
```
rake import:users filename=<filename>.xml
```

Example of users xml file can be found at ``spec/fixtures/users.xml``

### Execute tests
```
rspec
```

### Execute linters
```
rubocop
```

## Docker Application Usage

### Execute Application with Docker
```
docker-compose build
docker-compose run web rails db:create db:migrate db:seed
docker-compose run --service-ports web rails s -b 0.0.0.0
```

### Execute Tests with Docker
```
docker-compose build
docker-compose run web rails db:create db:migrate db:seed
docker-compose run web rspec
```

### Remove docker caches when no need anymore
```
docker system prune
```

### API

Create Transactions

POST **/api/transactions**

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

   To pass **Basic Auth** use existing Merchant **email** as username and his **password** like a password.
   **user_id** of Merchant in Basic Auth and **id** from Basic Auth should be the same.

To reset passwords for existing users:
1. Run Rails console
    ```
    rails c
    ```
2. Execute:
    ```
    User.all.each do |u|
      u.password = '<new password>'
      u.save!
    end
    ```
