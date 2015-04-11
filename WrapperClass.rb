class MailHelper
  attr_accessor :arg, :vlevel, :connected, :all_mails, :state_crit, :state_warn, :do_process
  
  def initialize(arg,vlevel)
    @vlevel               = vlevel
    @arg                  = arg
    @connected            = connected
    @all_new_mail         = []
    @all_new_subjects     = []
    @state_crit           = state_warn
    @state_warn           = state_crit
    @do_procees           = do_process
  end
 
  def parse_options
    ##Set command line variables
    @verbose               = arg[0]
    @emailaddress          = arg[1]
    @password              = arg[2]
    @url                   = arg[3]
    @port                  = arg[4]
    @mailbox               = arg[5]
    @output_file           = arg[6]
    
    if @emailaddress.nil?  == true || 
       @password.nil?      == true || 
       @url.nil?           == true ||
       @port.nil?          == true 
       self.display_options 
       @do_process         = false  
    else
       @do_process         = true
       #verbose setting
       @vlevel                = 1 if @verbose == "-v"    
       @mailbox               = 'INBOX' if @mailbox.nil?
       @output_file           = 'newmail.html' if @output_file.nil?
    end
  end
  
  def display_options
     puts "ARG0 Use Verbose mode -v"                                                 
     puts "ARG1 Please Supply an email address"
     puts "ARG2 Please Provide password for email account"
     puts "ARG3 Please provide email endpoint eg: imap.google.com"
     puts "ARG4 Please provide Imap port eg: 993"
     puts "ARG5 Please provide a mial box to search - INBOX by default"
     puts "ARG6 Please provide an output mail file - newmail.html by default"
  end
  
 #Connect and Check for New Mails 
 def check_mail
    #Connect and Check for New Mails
    mail_to_parse          = ImapCheck.new(@emailaddress,@url,@port,@password,@mailbox)
    mail_to_parse.connect_imap
    mail_to_parse.get_new_mail
    @connected             = mail_to_parse.imap_state
    @all_new_mails         = mail_to_parse.all_mails
    @all_new_subjects      = mail_to_parse.all_subjects
    processed_mail         = ParseMail.new(@all_new_subjects)
    processed_mail.populate_states
    @state_crit            = processed_mail.state_crit
    @state_warn            = processed_mail.state_warn  
  end
  
  def create_html
    ##create html mail results 
    template = HtmlTemplate.new(@output_file)
    @all_new_subjects.each  do |subject|
    template << subject.to_s
    template.display_as_html { |x| "<span class=\"number\">#{x} </span>" }
    end
  end
  
  def test_state    
    #Set Exit status based on State
    if @state_crit.size      >= 1
      puts "Critical : #{@state_crit.size} new Messages Found"
    else
      puts "OK : #{@state_crit.size} new Messages Found"
    end
      

    case 
      when @state_warn.size    >= 1
           puts "Warning  : #{@state_warn.size} new Messages Found"
      when @state_warn.size    < 1, 
           @state_crit.size    < 1
           puts "OK: No messages found"
      when @state_warn.size    < 1, 
           @state_crit.size    < 1
           puts "OK"
      when @state_warn.size    >= 1, 
           @state_crit.size    < 1
           puts "Warning"
      when @state_crit.size    < 1, 
           @state_warn.size    < 1
           puts "OK"
      end 
    end
end              
     
    
  