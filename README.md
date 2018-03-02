# Bouncer

## Who?

Adam Panzer, e-squared, adam.panzer@optimizely.com

## What?

Bouncer is an app that cross-checks all users in the Optimizely GitHub organization against the LDAP instance that houses all employees. The purpose is to ensure that:

* All new members of the organization are recognizable as optimizely employees
* Report any members of the GH org that are not optimizely employees (or contracts / consultants)

## Where?

Code for the project resides [here](https://github.com/optimizely/bouncer) and is run [here](https://jenkins.dz.optimizely.com/job/devops-bouncer/). The jankins job is configured to run on a cron schedule of once per day. When the job finishes, it makes a CSV of its findings and emails it to IT (which makes an ITSD ticket).

## When?

Once per day, at 8AM PST.

## Why?

After a brief stint with an IT Governance SaaS product that used our GH organization for testing, we did an audit to find several former Optimizely employees were still members of our GH organization. It became important to make sure that, when an employee is offboarded, they are removed from the GH organization in a timely manner. In addition, it was also important to ensure that when we added a user to our GH organization, that we were able to look up who that user is by some bit of indentifying information.

The standard practice, in IT, is to store the user's GH profile URL in Active Directory so that it can be cross-referenced to GH. If we onboard somebody and add them to the GH organization but their profile is not in Active Directory it will be flagged in the CSV. If we offboard somebody and they are still in our GH organization, it will also be flagged in the CSV sent to IT.

## How?

The process, from a high level, does the following:

Query GH for all members of the organization => For each GH member, make a query to Active Directory for the profile URL

## Secrets Needed

This project requires the following secrets from pistachio:

* namely
* github
* ad
* sendgrid

via the pistachio path "github-namely". You can bootstrap the project by running ./bin/bootstrap.sh
