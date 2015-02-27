# Fast trade
In this website users can create offers, for items/services in different categories
and find somone who want to buy or use it.

This site is hosted on [Heroku](https://fast-trade-8844.herokuapp.com/)

## Functionalities
1. Visitors
  - Non logged in guests of the site can:
    - Show offer index
    - Show active offers
2. Users
  - Registration, edition deletion of account
    - Administrators can edit and delete account, but cannot change user password
  - User account can be activated/deactivated by admin.
    - All offers that belongs to deactivated user become closed
  - User with deactivated account cannot:
    - Create offers
    - Send messages
  - User with deactivated account still can:
    - Show users profile