require 'spec_helper'


describe "#NagiosMailChecker" do
  before :each do
     @mail_to_parse      = ImapCheck.new("","lcvieira90@gmail.com","erildil20266","imap.gmail.com",993)
  end


  describe "#new Instance of ImapCheck" do
    it "takes four parameters (email, mail url, port, password) and returns a populated imap object" do
          @mail_to_parse.should be_instance_of(ImapCheck)
      end
  end


  describe "#get New mails from a mailbox" do
    it "checks imap object for email content" do
          @mail_to_parse.get_mails.should_not be_nil
    end
  end

  describe "#new Instance of ParseMail" do
    it "takes one parameter (subjects) and returns a populated object" do
          @mail_to_parse.get_mails
          subjects            = @mail_to_parse.get_mailsubjects
          processed_mail      = ParseMail.new(subjects)
          processed_mail.should be_instance_of(ParseMail)
    end
  end

  describe "#parse Subjects and return their states (Critical or Warning) " do
    it "checks Mail object for subject line containing Crit or Warn" do
          @mail_to_parse      = ImapCheck.new("lcvieira90@gmail.com","imap.gmail.com",993,"erildil20266")
          @mail_to_parse.get_mails
          subjects            = @mail_to_parse.get_mailsubjects
          processed_mail      = ParseMail.new(subjects)   
          processed_mail.populate_states
          @state_crit          = processed_mail.state_crit
          @state_crit.should_not be_nil     
    end
  end

  describe "#create HTML file to hold processed mail" do
    it "uses File method to create a new html file to hold processed email" do
          @mail_to_parse.get_mails
          subjects            = @mail_to_parse.get_mailsubjects
          processed_mail      = ParseMail.new(subjects)   
          processed_mail.populate_states
          @state_crit          = processed_mail.state_crit
          @state_warn          = processed_mail.state_warn
          template = HtmlTemplate.new
          subjects.each  do |subject|
            template << subject.to_s
            template.display_as_html { |x| "<span class=\"number\">#{x} </span>" }
          end
          file_exists = File.exists?("newmail.html")
          file_exists.should be_true
    end
  end
end
