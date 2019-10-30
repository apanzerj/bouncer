# Bouncer

## Who?

Adam Panzer

## What?

Bouncer is an app that cross-checks all users in a GitHub organization against an LDAP instance or other system. The purpose is to ensure that:

* All new members of the organization are recognizable as employees
* Report any members of the GH org that are not employees (or consultants)

## Where?

Code for the project resides [here](https://github.com/apanzerj/bouncer).


## How?

The process, from a high level, does the following:

Query GH for all members of the organization => For each GH member, make a query to Active Directory for the profile URL

## Secrets and Config

1. Github Access Token
2. An org name (ie: the name of the org)
3. LDAP access (if checking against LDAP)
