#!/usr/bin/ruby

##Name:              NagiosMmailChecker.rb
##Created By:        kevin brannigan
##Program:           to retrive email and alert based on subject line
##Last Updated:      23-05-2013
##changes:           Code Review 2 - blocks, helper class, rspec

##Required Ruby gems
require './LibraryHelper'

arg = ARGV
get_mail = MailHelper.new(ARGV,0)
get_mail.parse_options

if get_mail.do_process == false
  exit 0
else
  get_mail.check_mail
  get_mail.test_state
  get_mail.create_html
end




