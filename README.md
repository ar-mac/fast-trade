# Fast trade
In this website users can create offers, for items/services in different categories
and find somone who want to buy or use it.

This site is hosted on [Heroku](https://fast-trade-8844.herokuapp.com/)

## Functionalities
1. Visitors
    - Non logged in guests of the site can:
        - Show offer index
        - Show only active offers
2. Users
    - Registration
        - Administrators can edit and delete account, but cannot change user password
    - User account can be activated/deactivated by admin.
        - All offers that belongs to deactivated user become closed
    - User with deactivated account cannot:
        - Edit his account
        - Create offers
        - Send messages
    - User with deactivated account still can:
        - Show users profile
    - User normally can:
      - Edit account
          - Change regular data (admins can)
          - Change password when old password is provided (admins cannot)
      - Delete account (admins can)
      - Create offers
      - Close their offers (admins can)
      - Renew their closed offers (admins cannot)
      - Delete their offers (admins can)
      - Send message according to active offer to the owner
      - Offer owner can recieve messages from multiple users interested in their offer
      - Show other __active__ users and their __active__ offers (admins dont have such restrictions)
      - In offer index they can only show __active__ offers (admins dont have such restrictions)
3. Admins
    - Can see index of all users
    - Can do with their account/offers everything, that regular users can
4. Messagebox (is not AR object, just collection of issues send to/by user)
    - Individual for each user (cannot be look up by admins)
    - Sending first message creates issue for that offer between owner and specific user
    - Issues are deleted automatically after:
        - 30 days from last send message
        - 3 days if __both__ users deactivate it
    - Issue is automatically activated when message is posted in it
5. Offers
    - Have expiration date
    - When the date is passed, offer becomes closed (due to whenever trouble it is hancled by after_action clearing in offers index)
6. Languages
    - Site has full support for translations
    - Is avalible in polish(default), english, and spanish version
    - All site users/visitors can change language in which site will be presented
7. If this project will be continnued, I would like to implement:
    - Resetting password and using mailers to confirm account etc.
    - Reporting administration inproper contents, names, behaviours
    - Contatct with administration
    - Inspect search querries in all places, to decide is there need to add/remove index on columns
    - Optimalize and refactor css and views templates
    - Add offer tags (I didn't understand the idea written in the exerecise)
    - Add selecting date in search form by gem date selectors
    - Different currencies, which are automatically converted to currency connected with chosen language. Exchange rate would be obtained from other page (National Bank of Poland?) 
    - Links use offer.title, user.name etc. rather than :id

## Other info
1. Site is not based on gem devise
    - I tried to build registration/login system on my own.
    - Next time I'll use devise
2. Admins are users with attribute admin = true
    - This attribute can be modified only by server console
    - Not most OO solution, but for the first project it works.
3. Automatic events, based on time, are handled by gem whenever
    - Currently not working :/, but probably it's the case of Rails.env (need to be production)
4. This app has full (?) test suite for main functionalities
    - Tests are automatically connected with files by gem guard