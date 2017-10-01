require 'httparty'
require 'json'
require 'time'
require 'set'

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
    if @token == '' and !issue_token(get_key('pk'), get_key('sk'))
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
      try_api(url, add_params)
    else
      puts "Error code: " + api_response.code
      'no token'
    end
  end
  
  
  def self.this_Month_Jobs(req_state, limit=20, add_params=false)
    # month = Time.now.month.to_s
    month = "9"
    year = Time.now.year.to_s
    if month.length == 1 then month = '0' + month  end
    count = 0
    page_count = 1
    id_set = Set.new
    
    puts "////////////// checking state:" + req_state + " //////////////"
    while page_count <= limit
      # puts "********** page:" + page_count.to_s
      if req_state == ''
        data = try_api(WON_ADDR+JOB_REQS, {page: page_count})
      else
        data = try_api(WON_ADDR+JOB_REQS, {state: req_state, page: page_count})
      end
      
      if data != 'no token'
        data = data["job_requests"]
        data.each do |dict|
          resp_month = dict["updated_at"][5,2] 
          resp_year= dict["updated_at"][0,4] 
          if resp_month == month and resp_year == year
            job_id = dict["id"]
            if !id_set.include?(job_id)
              count += 1
              id_set.add(job_id)
            else
              # puts id_set.inspect()
              limit = page_count
              break
            end
          end
        end
      else 
        puts "no token"
        limit = page_count
      end
      page_count += 1
    end
    puts "count: " + count.to_s
    puts "checked " + (page_count - 1).to_s + " pages"
    count
  end
  
end