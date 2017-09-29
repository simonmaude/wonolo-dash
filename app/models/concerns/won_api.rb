require 'httparty'
require 'json'

class Won_api 
  
  @token = ''
  WON_ADDR = "https://api.wonolo.com/api_v2/"
  AUTH = "authenticate"
  JOB_REQS = "job_requests"
  JOBS = "jobs"
  MESS = "messages"
  SRCH = "search"
  USER = "users"
  
  
  def self.get_key(key_type)
    if key_type == 'pk'
      Rails.application.secrets.w_pk_key
    elsif key_type == 'sk'
      Rails.application.secrets.w_sk_key
    else
      key_type + " is not a valid key"
    end
  end
  
  
  def self.issue_token(p_key, s_key)
    response = HTTParty.post(WON_ADDR+AUTH, body: {api_key: p_key, secret_key: s_key})
    @token = response["token"]
    @token ? true : false 
  end
  
  
  def self.try_api(url, add_params=false)
    if @token == '' and !self.issue_token(self.get_key('pk'), self.get_key('sk'))
      puts 'invalid keys'
      @token = ''
      return 'no token'
    end
    
    if not add_params
      api_response = HTTParty.get(url, query: {token: @token})
    else 
      query_hash = {token: @token}.merge(add_params)
      api_response = HTTParty.get(url, query: query_hash)
    end
    
    if api_response.code == 200
      api_response
    elsif api_response.code == 401
      @token = ''
      Won_api.try_api(url, add_params)
    else
      puts "Error code: " + api_response.code
      'no token'
    end
  end
  
  
end