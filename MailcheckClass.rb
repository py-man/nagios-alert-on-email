class ImapCheck
  attr_accessor :email_address, :url, :port, :password, :all_subjects, :all_mails, :mbox, :imap_state, :all_mails, :all_subjects
  
  def initialize(email_address,url,port,password,mbox)
    @email_address       = email_address
    @url                = url
    @port               = port
    @password           = password
    @all_subjects       = []
    @all_mails          = []
    @mbox               = mbox
    @imap_state         = imap_state
    @all_mails          = all_mails
    @all_subjects       = all_subjects
    @imap               = []
  end
  
  ##Connect to Server and Get Email
  def connect_imap
    user                = @email_address
    pass                = @password
    @imap               = Net::IMAP.new(@url, @port, usessl = true, certs = nil, verify = false)
    @imap_state         = @imap.login(user, pass)
    @imap.select(mbox)
  end
  
  ##Search Inbox for all UNREAD messages and display
  def get_new_mail   
    @imap.select(@mbox)      
    @imap.search(['ALL', "SEEN"]).each do |message_id|
      msg             = @imap.fetch(message_id,'RFC822')[0].attr['RFC822']
      mail            = Mail.read_from_string msg
      ##Populate Arrays with Mails and Subjects
      @all_subjects.push(mail.subject)
      @all_mails.push(mail.text_part.body.to_s)
    end
  end
  
end

##Parse The subject line of each mail
class ParseMail
  attr_accessor :on_subject, :state_crit, :state_warn
  
  def initialize(on_subject)
    @on_subject         = on_subject
    @state_crit         = []
    @state_warn         = []
  end

  def populate_states
    @on_subject.each do |subject|
      if subject.include? "State:Critical"
        @state_crit.push(subject)
      end
      if subject.include? "State:Warning"
        @state_warn.push(subject)
      end       
    end
  end
end  


class HtmlTemplate < Array
  attr_accessor :html_file
  
  def initialize(html_file)
    @html_file          = html_file
    @does_exist         = []
  end
  
  def display_as_html
    @html_file = "newmail.html" if @html_file.nil?
    @does_exist = File.exist?(@html_file)
    if @does_exist 
      File.delete(@html_file)
    end
    outfile = File.new(@html_file, "w")
    html_template_header = "<html>
                            <head><title>Nagios Mail Checks</title></head>
                            <body>
                            <h2>"
    outfile.puts(html_template_header)                       
    
    self.each { |x| outfile.puts(yield(x)) }
    
    html_template_footer = "</h2>
                            </body>'
                            </html>"  
    outfile.puts(html_template_footer) 
    outfile.puts()
    outfile.close
   end
end 