db.user.update(
  { 'email' : "hooplaAdmin@localruckus.com"}, 
  {$push:
    { 'applications':
        { 'name' : 'localruckus-mobile', 'apiKey' : 'hrdfepSzzPeOCWoUSoT5', 'apiSecret' : '6X62QuHGBdR1pLNMqPJQ0TNJUOVr0gKGZUyDIM5m', 'privileges':'STANDARD'}
    }
  }
);