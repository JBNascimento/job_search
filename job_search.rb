#!/usr/bin/env ruby

require 'twitter' #https://github.com/sferik/twitter
require 'mail'    #https://github.com/mikel/mail

def send_mail(jobs)
    Mail.defaults do
        delivery_method :smtp, {
          address: "smtp.gmail.com",
          port: 587,
          user_name: "xxxxx@gmail.com",
          password: "<password>",
          authentication: :plain,
          enable_starttls_auto: true
        }
      end
      
      Mail.deliver do
        from    "Name <xxx@mail.com>"
        to      "xxx@mail.com"
        subject 'Vagas Dev Jr - Twitter'
        html_part do
            content_type 'text/html; charset=UTF-8'
            body  jobs
        end
      end
end

while true
    begin
        # Create a read write application from : 
        # https://apps.twitter.com
        # authenticate it for your account
        # fill in the following
        config = {
            consumer_key:        'xxxxxxx',
            consumer_secret:     'xxxxxxx',
            access_token:        'xxxxxxx',
            access_token_secret: 'xxxxxxx'
        }
        sClient = Twitter::Streaming::Client.new(config)

        # topics to watch
        topics = ['vaga desenvolvedor', 'desenvolvedor jr', 'desenvolvedor junior', 'vaga ruby on rails']
        jobs = Array.new
        sClient.filter(:track => topics.join(',')) do |tweet|
            if tweet.is_a?(Twitter::Tweet)  
              puts tweet.full_text.to_s                
              jobs.push("<p>#{tweet.full_text.to_s} + <a href='#{tweet.uri.to_s}'> Ver Tweet </a></p>")
              if jobs.length == 5
                send_mail(jobs)
                jobs.clear   
                puts jobs.length
              end
            end
        end
    rescue
        puts 'Error occurred, waiting for 5 seconds'
        sleep 5
    end

end