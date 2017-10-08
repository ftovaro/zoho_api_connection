## Zoho API Connection ##
**Zoho API Connection** is an API where you can search **leads** from Zoho CRM. You can easily connect with any client (e.g mobile app or front-end app) using this API and manage you leads easily.

## Installation ##

First of all, this app was created with **Ruby 2.4.1** and **Rails 5.1.4**. We use **Postgresql** as DB so get that ready before anything. 

After you have cloned the project, go inside the folder a run `bundle install`, then `rails db:create db:migrate db:seed` as a single command to create the DB, run migrations and fetch some data from ZOHO.

Once done, you can start the server with `rails s -p 3001`

## Pagination ##

All endpoints receive a `records` and `page` param that you can use as pagination for your client.

## Endpoints ##
***
### Search by name, company or phone ###

With this endpoint you can look for a phone like `555` and it'll bring you all phones that have a coincidence with that number. Not all params are required to do a request.

| url | HTTP method | description | status |
|---|---|---|---|
| `/api/v1/leads/search_others?name=James&phone=555&records=1&page=1` | GET | returns leads that meet the search criteria | 200 |

**Request params**

| key | value |
|---|---|
| **`name`** | E.g. `James` |
| **`company`** | E.g. `Web` |
| **`phone`** | E.g. `555` |
| **`records`** | E.g. `2` |
| **`page`** | E.g. `2` |

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

### Search by source ###

With this endpoint you can look for a source like `adver` and it'll bring you all source that have a coincidence with that word like `Advertisement`.

| url | HTTP method | description | status |
|---|---|---|---|
| `/api/v1/leads/seach_source?source=adver&records=2&page=1` | GET | returns leads that meet the search criteria | 200 |

**Request params**

| key | value |
|---|---|
| **`source`** | E.g. `adver` |
| **`records`** | E.g. `2` |
| **`page`** | E.g. `1` |

**Response headers**

| key | value |
|---|---|
| **`Content-Type`** | application/json; charset=utf-8 |


**Response body**
```javascript
[
  {
    "id": 70,
    "name": "Carissa",
    "company": "Oh My Goodknits Inc",
    "phone": "555-555-5555",
    "source": "Advertisement",
    "created_at": "2017-10-07T17:06:00.520Z",
    "updated_at": "2017-10-07T17:06:00.520Z",
    "mobile": "555-555-5555",
    "zoho_id": "2788672000000133118"
  },
  {
    "id": 78,
    "name": "Chau",
    "company": "Creative Business Systems",
    "phone": "555-555-5555",
    "source": "Advertisement",
    "created_at": "2017-10-07T17:06:00.573Z",
    "updated_at": "2017-10-07T17:06:00.573Z",
    "mobile": "555-555-5555",
    "zoho_id": "2788672000000133110"
  }
]
```
***
### Submit a lead from Zoho ###

This endpoint allows you to submit a lead from Zoho to this DB using a Zoho ID or a phone number. As a Zoho ID is unique, this endpoint priorize the use of an ID over a phone number. If the lead already exited in DB it'll only return it.

| url | HTTP method | description | status |
|---|---|---|---|
| `/api/v1/leads/search_lead?id=2788672000000133118` | GET | returns leads that meet the submit criteria | 200 |
| `/api/v1/leads/search_lead?phone=555-555-5555` | GET | returns leads that meet the submit criteria | 200 |

**Request params**

| key | value |
|---|---|
| **`id`** | E.g. `2788672000000133118` |
| **`phone`** | E.g. `555-555-5555` |
| **`mobile`** | E.g. `555-555-5555` |

**Response headers**

| key | value |
|---|---|
| **`Content-Type`** | application/json; charset=utf-8 |


**Response body**
```javascript
[{
   "id": 70,
   "name": "Carissa",
   "company": "Oh My Goodknits Inc",
   "phone": "555-555-5555",
   "source": "Advertisement",
   "created_at": "2017-10-07T17:06:00.520Z",
   "updated_at": "2017-10-07T17:06:00.520Z",
   "mobile": "555-555-5555",
   "zoho_id": "2788672000000133118"
}]
```
***
