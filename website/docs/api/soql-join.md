---
sidebar_position: 5
---

# JoinQuery

## of

Conctructs an `JoinQuery`.

**Signature**

```apex
static JoinQuery of(sObjectType ofObject)
```

**Example**

```sql
SELECT Id
FROM Account
WHERE Id IN (
    SELECT AccountId
    FROM Contact
    WHERE Name = 'My Contact'
)
```
```apex
SOQL.of(Account.sObjectType)
    .whereAre(SOQL.Filter.with(Account.Id).isIn(
        SOQL.InnerJoin.of(Contact.sObjectType)
            .with(Contact.AccountId)
    )).asList();
```

## field

> `SELECT` statement that specifies the fields to query.

**Signature**

```apex
static JoinQuery with(sObjectField field)
```

**Example**

```sql
SELECT Id
FROM Account
WHERE Id IN (
    SELECT AccountId
    FROM Contact
)
```
```apex
SOQL.of(Account.sObjectType)
    .whereAre(SOQL.Filter.with(Account.Id).isIn(
        SOQL.InnerJoin.of(Contact.sObjectType)
            .with(Contact.AccountId)
    )).asList();
```

## whereAre

> The condition expression in a `WHERE` clause of a SOQL query includes one or more field expressions. You can specify multiple field expressions in a condition expression by using logical operators.

For more details check [`QB.FiltersGroup`](soql-filters-group.md) and [`QB.Filter`](soql-filter.md)

**Signature**

```apex
static JoinQuery whereAre(FiltersGroup conditions)
```

**Example**

```sql
SELECT Id
FROM Account
WHERE Id IN (
    SELECT AccountId
    FROM Contact
    WHERE Name = 'My Contact'
)
```
```apex
SOQL.of(Account.sObjectType)
    .whereAre(SOQL.Filter.with(Account.Id).isIn(
        SOQL.InnerJoin.of(Contact.sObjectType)
            .with(Contact.AccountId)
            .whereAre(SOQL.Filter.with(Contact.Name).equal('My Contact'))
    )).asList();
```