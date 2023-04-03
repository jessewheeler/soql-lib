---
sidebar_position: 3
---

# Basic Features

## Dynamic SOQL

`SOQL.cls` class provide methods that allow build SOQL clauses dynamically.

```apex
// SELECT Id FROM Account LIMIT 100
SOQL.of(Account.sObjectType).with(new List<sObjectField> {
    Account.Id, Account.Name
})
.setLimit(100)
.asList();
```


## Automatic binding

All variables used in `WHERE` condition are binded by default.

```apex
// SELECT Id, Name FROM Account WHERE Name = :v1
SOQL.of(Account.sObjectType).with(new List<sObjectField> {
    Account.Id, Account.Name
})
.whereAre(SOQL.Filter.with(Account.Name).likeAny('Test'))
.asList();
```

```apex
// Binding Map
{
  "v1" : "%Test%"
}
```

## Control FLS

[AccessLevel Class](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_System_AccessLevel.htm)

Object permission and field-level security is controlled by the framework. Developer can change FLS settings match business requirements.

### User mode

By default all queries are in `AccessLevel.USER_MODE`.

> The object permissions, field-level security, and sharing rules of the current user are enforced.

### System mode

Developer can change it by using `.systemMode()` which apply `AccessLevel.SYSTEM_MODE`.

> The object and field-level permissions of the current user are ignored, and the record sharing rules are controlled by the sharingMode.

```apex
// SELECT Id FROM Account - skip FLS
SOQL.of(Account.sObjectType).with(new List<sObjectField> {
    Account.Id, Account.Name
})
.systemMode()
.asList();
```

## Control Sharings

[Apex Sharing](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_keywords_sharing.htm)

> Use the with sharing or without sharing keywords on a class to specify whether sharing rules must be enforced. Use the inherited sharing keyword on a class to run the class in the sharing mode of the class that called it.

### with sharing

By default all queries will be executed `with sharing`, because of `AccessLevel.USER_MODE` which enforce sharing rules.

`AccessLevel.USER_MODE` enforce object permissions and field-level security as well.

Developer can skip FLS by adding `.systemMode()` and `.withSharing()`.

```apex
// Query executed in without sharing
SOQL.of(Account.sObjectType).with(new List<sObjectField> {
    Account.Id, Account.Name
})
.systemMode()
.withSharing()
.asList();
```

### without sharing

Developer can control sharing rules by adding `.systemMode()` (record sharing rules are controlled by the sharingMode) and `.withoutSharing()`.

```apex
// Query executed in with sharing
SOQL.of(Account.sObjectType).with(new List<sObjectField> {
    Account.Id, Account.Name
})
.systemMode()
.withoutSharing()
.asList();
```

### inherited sharing

Developer can control sharing rules by adding `.systemMode()` (record sharing rules are controlled by the sharingMode) by default it is `inherited sharing`.

```apex
// Query executed in inherited sharing
SOQL.of(Account.sObjectType).with(new List<sObjectField> {
    Account.Id, Account.Name
})
.systemMode()
.asList();
```

## Mocking

```apex
public with sharing class ExampleController {

    public static List<Account> getPartnerAccounts(String accountName) {
        return AccountSelector.Query
            .with(Account.BillingCity)
            .with(Account.BillingCountry)
            .whereAre(SOQL.FiltersGroup
                .add(SOQL.Filter.with(Account.Name).likeAny(accountName))
                .add(SOQL.Filter.recordType().equal('Partner'))
            )
            .mockId('ExampleController.getPartnerAccounts')
            .asList();
    }
}
```

```apex
@isTest
public class ExampleControllerTest {

    public static List<Account> getPartnerAccounts(String accountName) {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'MyAccount 1'),
            new Account(Name = 'MyAccount 2')
        };

        SOQL.setMock('ExampleController.getPartnerAccounts', accounts);

        // Test
        List<Account> result = ExampleController.getAccounts('MyAccount');

        Assert.areEqual(accounts, result);
    }
}
```

## Avoid duplicates

Generic SOQLs can be keep in selector class.

```apex
public inherited sharing class AccountSelector {

    public static SOQL Selector {
        get {
            return SOQL.of(Account.sObjectType).with(new List<sObjectField>{
                Account.Name,
                Account.AccountNumber
            })
            .systemMode()
            .withoutSharing();
        }
    }

    public static SOQL getByRecordType(String rtDevName) {
        return Selector.with(new List<sObjectField>{
            Account.BillingCity,
            Account.BillingCountry
        }).whereAre(SOQL.Filter.recordType().equal(rtDevName);
    }

    public static SOQL getById(Id accountId) {
        return Selector.whereAre(SOQL.Filter.id().equal(accountId));
    }
}
```

## Default configuration

The selector class can provide default SOQL configuration like default fields, FLS settings, and sharing rules.

```apex
public inherited sharing class AccountSelector {

    public static SOQL Selector {
        get {
            return SOQL.of(Account.sObjectType)
                .with(new List<sObjectField>{  // default fields
                    Account.Id,
                    Account.Name
                })
                .systemMode(); // default FLS mode
        }
    }
}
```