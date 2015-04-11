# nagios-alert-on-email
-Nagios check that uses email as a event trigger

LibraryHelper.rb

==> Defines all the requirements and gem files

nagios-mailchecker.rb 

==> Main file that calls the methods to create and parse email based on subjects

WrapperClass.rb

==> A wrapper script around the IMAP and Parse classes - called by the main nagiosmailchecker file

MailcheckClass.rb

==> Contains the ImapCheck and ParseMail classes and methods that do the connectiity and physical parsing 

Spec (NagiosMailChecker_spec.rb , spec_helper.rb)

==> Unit tests for each of the NagiosMailChecker functions

Examples NagiosMailChecker_spec.rb

==>  rspec mailcheck_unittest_spec.rb --format nested
==>  rspec mailcheck_integrationtest_spec.rb --format nested
==>  Tests #NagiosMailChecker
==>  Tests #new Instance of ImapCheck
==>  takes four parameters (email, mail url, port, password) and returns a populated imap object

Examples NagiosMailChecker.rb

==>   ruby ./NagiosMailChecker.rb   -v lcvieira90@gmail.com **** imap.gmail.com 993 INBOX newmail.html
==>   ruby ./NagiosMailChecker.rb   lcvieira90@gmail.com  **** imap.gmail.com 993 
	  
==>   options:
ARG0 Use Verbose mode -v
ARG1 Please Supply an email address
ARG2 Please Provide password for email account
ARG3 Please provide email endpoint eg: imap.google.com
ARG4 Please provide Imap port eg: 993
ARG5 Please provide a mial box to search - INBOX by default
ARG6 Please provide an output mail file - newmail.html by default
      

==>  Verbose::
	 Deleting / Recreating Existing File newmail.html
	 [State:Critical] ASH-PROD OMS0001: HOST DOWN ALERT
	 [State:Warning] ASH-PROD OMS0002: HOST DOWN ALERT2
	 [State:Warning] ASH-PROD OMS0005: Services are BUSTED 
