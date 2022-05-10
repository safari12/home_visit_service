# HomeVisitService

## Installation

Note: username and password for the postgres database can be set with the following variables:
```
export DB_USER="<username>"
export DB_PASS="<password>"
```

Install Dependencies
```
mix deps.get
```

Create and migrate your database
```
mix ecto.setup
```

Run Server
```
mix phx.server
```

## Usage

To interact with the graphql api following this link ```http://localhost:4000/graphiql```. It should take you to an interactive graphql gui interface. The following are mutations and queries the api supports

----

## ```Authentication```
The api supports authentication for users to create an account and authenticate through JsonWebToken by pasting it in the ```Authorization``` bearer header ```Bearer <token>```

Each account can be associated with a health plan, the available health plans are basic, immediate, advance. Each giving a specific amount of minutes to their account (remaining_minutes field)


```To sign up for member account with health plan```
```graphql
mutation SignUp {
  signup(
    email: "member@homeservice.com",
    firstName: "member",
    lastName: "member",
    password: "blah69blah",
    healthPlanId: "basic"
  ) {
    token
  }
}
```

```To sign up for pal account without health plan```
```graphql
mutation SignUp {
  signup(
    email: "pal@homeservice.com",
    firstName: "pal",
    lastName: "pal",
    password: "blah69blah"
  ) {
    token
  }
}
```

```Query current user details```
```graphql
query Me {
  me {
    email
    remainingMinutes
    healthPlanId
  }
}
```

----
## ```Health Plans```

The api comes with supported health plans of type basic, immediate, and advance

```Query health plans```
```graphql
query HealthPlans {
  healthPlans {
    planType
    minutes
    price
  }
}
```

----
## ```Visits```
When a member request a visit, it will debit from the account the visit's duration from their remaining_minutes. If an account tried to request a visit duration greater than the minutes they have the api respond with an error. When a pal fulfills a visit, it gets credited to their account's remaining_minutes. Accounts cannot not fulfill their own visit.

A visit's status will change when fulfilled

Also when a user request or fulfills a visit it goes through a database transaction in which if any of the steps fail it will rollback automattically

For a visit the following tasks are supported
```
COMPANIONSHIP
CONVERSATION
COOKING_MEALS
GROCERY_SHOPPING
HOUSEKEEPING
LAUNDRY_SERVICE
RUNNING_ERRANDS
```

```Request a visit```
<br />
Note: this api call requires the Authentication Token in Header
```graphql
mutation RequestVisit {
  requestVisit(
    date: "2022-05-09", 
    minutes: 60, 
    tasks: [GROCERY_SHOPPING]
  ) {
    date
    memberId
    minutes
    status
    tasks
  }
}
```

```Fulfill a visit```
<br />
Note: this api call requires the Authentication Token in Header
```graphql
mutation FulfillVisit {
  fulfillVisit(visitId: 1) {
    id
    memberId
    status
    transaction {
      memberId
      palId
      visitId
    }
  }
}
```

``` Get visits by status ```
<br />
Get pending visits
```graphql
query PendingVisits {
  visits(status:PENDING) {
    id
    memberId
    minutes
    status
    date
  }
}
```
Get fulfilled visits
```graphql
query PendingVisits {
  visits(status:FULFILLED) {
    id
    memberId
    minutes
    status
    date
  }
}
```

