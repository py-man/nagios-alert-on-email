require 'spec_helper'

###add rcov examples also and before and after


describe "#passed correct command_line arguments?" do
    it "requires four parameters (email, mail url, port, password) and returns a boolean of true" do
          arg = ["lcvieira90@gmail.com","imap.gmail.com",993,"erildil20266"]
          get_mail = MailHelper.new(arg,0)
          get_mail.do_process.should be_false
    end
end

describe "#new Instance of ImapCheck?" do
    it "initilizes a new instance of the ImapCheck class" do
      @mail_to_parse      = ImapCheck.new("lcvieira90@gmail.com","imap.gmail.com",993,"erildil20266","INBOX")
      @mail_to_parse.should be_instance_of(ImapCheck)
    end
end

describe "#connect to mailbox?" do
    it "connects to a imap mailbox and returns connection status" do
      @mail_to_parse      = ImapCheck.new("lcvieira90@gmail.com","imap.gmail.com",993,"erildil20266","INBOX")
      @mail_to_parse.should be_instance_of(ImapCheck)
      @mail_to_parse.connect_imap
      @mail_to_parse.connect_imap.to_s.should include "Success" 
    end
end

describe "#got new mail?" do
    it "Retrives email from mailbox" do
      @mail_to_parse      = ImapCheck.new("lcvieira90@gmail.com","imap.gmail.com",993,"erildil20266","INBOX")
      @mail_to_parse.connect_imap
      @mail_to_parse.get_new_mail
      @mail_to_parse.all_mails.to_s.should include "From"  
    end
end
          
describe "#new Instance of ParseMail?" do
    it "initilizes a new instance of the ParseMail class" do
      @mail_to_parse      = ImapCheck.new("lcvieira90@gmail.com","imap.gmail.com",993,"erildil20266","INBOX")
      @mail_to_parse.connect_imap
      @mail_to_parse.get_new_mail
      @all_new_subjects      = @mail_to_parse.all_subjects
      processed_mail         = ParseMail.new(@all_new_subjects)
      processed_mail.should be_instance_of(ParseMail)    
    end
end

describe "#populate alert states?" do
    it "populate state based on mail subject" do
      @mail_to_parse      = ImapCheck.new("lcvieira90@gmail.com","imap.gmail.com",993,"erildil20266","INBOX")
      @mail_to_parse.connect_imap
      @mail_to_parse.get_new_mail
      @all_new_subjects      = @mail_to_parse.all_subjects
      processed_mail         = ParseMail.new(@all_new_subjects)
      processed_mail.populate_states
      state_crit            = processed_mail.state_crit
      state_crit.to_s.should include "Critical" 
    end
end

describe "#test alert states?" do
    it "test alert states for critical or warnings" do
      @mail_to_parse      = ImapCheck.new("lcvieira90@gmail.com","imap.gmail.com",993,"erildil20266","INBOX")
      @mail_to_parse.connect_imap
      @mail_to_parse.get_new_mail
      @all_new_subjects      = @mail_to_parse.all_subjects
      processed_mail         = ParseMail.new(@all_new_subjects)
      processed_mail.populate_states
      state_crit            = processed_mail.state_crit
      state_crit.size.should  >= 1
    end
end
      
describe "#create html file?" do
    it "create htmlfile to hold new messages" do
      does_exist = File.exist?("newmail.html")
      does_exist.should be_true
    end
end
