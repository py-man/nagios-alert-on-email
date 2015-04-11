require 'spec_helper'

describe "#test end to end checkmail?" do
    it "Test all variable outputs, all must be true" do
      @mail_to_parse              = ImapCheck.new("lcvieira90@gmail.com","imap.gmail.com",993,"erildil20266","INBOX")
      @mail_to_parse.connect_imap
      @mail_to_parse.get_new_mail
      @all_new_subjects           = @mail_to_parse.all_subjects
      processed_mail              = ParseMail.new(@all_new_subjects)
      processed_mail.populate_states
      state_crit                  = processed_mail.state_crit
      @mail_to_parse.connect_imap.to_s.should include "Success" and  
      @mail_to_parse.all_mails.to_s.should include "From" and 
      state_crit.size.should      >= 1     
    end
end

describe "#test if incorrect command line options passed?" do
    it "Test condition where command options are wrong" do
      arg = ARGV
      get_mail = MailHelper.new(ARGV,0)
      get_mail.do_process.should be_false
      end
end

describe "#test when verbose is on?" do
    it "test when vlevel is set to on" do
      arg                         = ARGV
      get_mail                    = MailHelper.new(ARGV,0)
      get_mail.vlevel             = 0
      get_mail.vlevel.should      == 0
    end
end

describe "#test when state crit or warn are false?" do
    it "Test output and results when no new critical messages are found" do
      @mail_to_parse              = ImapCheck.new("lcvieira90@gmail.com","imap.gmail.com",993,"erildil20266","INBOX")
      @mail_to_parse.connect_imap
      @mail_to_parse.get_new_mail
      @all_new_subjects           = @mail_to_parse.all_subjects
      processed_mail              = ParseMail.new(@all_new_subjects)
      processed_mail.on_subject   = []
      processed_mail.populate_states
      state_crit                  = processed_mail.state_crit
      state_crit.should be_empty
    end
end

describe "#test when no mails are found or connection issues" do
    it "Test condition where new mails is false" do
      all_new_subjects            = ["none"]
      processed_mail              = ParseMail.new(all_new_subjects)
      processed_mail.populate_states
      state_crit                  = processed_mail.state_crit
      state_crit.should  be_empty
    end
end


