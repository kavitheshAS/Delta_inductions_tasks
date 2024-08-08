# Onsites - Day 1

You are provided with a log file named network_usage.log containing detailed records of network usage for different users in a multi-tenant system. Each record contains
Timestamp, Username, IP Address, Data Downloaded (in MB), Data Uploaded (in MB), Billing Status (Billed or Unbilled).
Your task is to calculate the total unbilled network usage cost per user. The billing rate is $0.05 per MB of data (both downloaded and uploaded). The output should be a file named network_bills.txt with the username and the total amount due, sorted by the highest amount due first.

Additionally:

Identify the top 3 users with the highest unbilled usage and log their details separately and
provide a summary of the total amount due across all users.