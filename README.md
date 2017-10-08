## ZOHO API Connection ##
**ZOHO API Connection** is an API where you can search **leads** from ZOHO CRM. You can easily connect with any client (e.g mobile app or front-end app) using this API and manage you leads easily.

## Installation ##

First of all, this app was created with **Ruby 2.4.1** and **Rails 5.1.4**. We use **Postgresql** as DB so get that ready before anything. 

After you have cloned the project, go inside the folder a run `bundle install`, then `rails db:create db:migrate db:seed` as a single command to create the DB, run migrations and fetch some data from ZOHO.

Once done, you can start the server with `rails s`

***
### Search by name, company or phone ###

| url | HTTP method | description | status |
|---|---|---|---|
| `/api/v1/leads/search_others?name=James&phone=555&records=1&page=1` | GET | returns leads that meet the search criteria | 200 |

**Request Header**

| key | value |
|---|---|
| **`Content-Type`** | application/json |

**Response headers**

| key | value |
|---|---|
| **`Content-Type`** | application/json; charset=utf-8 |


**Response body**
```javascript
[{
  "id": 71,
  "name": "James",
  "company": "Kwik Kopy Printing",
  "phone": "555-555-5555",
  "source": "Web Download",
  "created_at": "2017-10-07T17:06:00.530Z",
  "updated_at": "2017-10-07T17:06:00.530Z",
  "mobile": "555-555-5555",
  "zoho_id": "2788672000000133117"
}]
```
***
