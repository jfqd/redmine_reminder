require 'cgi'
require 'net/https'
require 'rexml/document'

class ReminderSms
  
  # Send sms notification
  def self.send_notification(phone_numbers, text)
    numbers = phone_numbers.split(",").collect(&:strip)
    numbers.each { |number| send_sms(number,text) }
  end
  
  private
  
  def send_sms(number, text, params={})
    # setup query parameters
    params['version']  = '3.0'
    params['cid']      = settings['sms_gateway_uid']
    params['password'] = settings['sms_gateway_pwd']
    params['to']       = number
    params['from']     = settings['sms_gateway_sender_phone_number']
    params['content']  = text.encode("ISO-8859-1")
    # http://www.rubyinside.com/nethttp-cheat-sheet-2940.html
    uri = URI.parse("#{settings['sms_gateway_url']}#{settings['sms_gateway_path']}?#{querify(params)}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    req = Net::HTTP::Get.new( uri.request_uri )
    response = http.request(req)
    return response.code == 200 ? true : false
    # https://smsserver.mindmatics.com/messagegateway/errorcodes/
    d = REXML::Document.new(response.body)
    r = d.root.elements["/result"].text
    Rails.logger.warn("[ReminderSms#send_notification] sms send: #{d}")
  rescue => e
    Rails.logger.warn("[ReminderSms#send_notification] Error while sending sms notification (#{e.message})")
    false
  end
  
  def querify(query_hash)
    query_hash.map { |name, value| "#{CGI.escape(name.to_s)}=#{CGI.escape(value.to_s)}" }.join('&')
  end
  
end
