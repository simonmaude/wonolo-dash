require 'httparty'
require 'json'
require 'time'
require 'set'

class Won_api 
  
  @token = ''
  JOB_ADDR = "https://api.wonolo.com/api_v2/jobs"
  JOB_REQS_ADDR = "https://api.wonolo.com/api_v2/job_requests"
  AUTH_ADDR = "https://api.wonolo.com/api_v2/authenticate"
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
    response = HTTParty.post(AUTH_ADDR, body: {api_key: p_key, secret_key: s_key})
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
    month = Time.now.month.to_s
    if month.length == 1 then month = '0' + month  end
    count = 0
    page_count = 1
    # diffTStamps = []
    empStates = Hash.new 0
    id_set = Set.new
    
    puts "////////////// checking state: " + req_state + " //////////////"
    while page_count <= limit
      puts "********** page:" + page_count.to_s + ", current count: " + count.to_s
      if req_state == ''
        data = try_api(JOB_ADDR, {page: page_count, per: 50})
      else
        data = try_api(JOB_ADDR, {state: req_state, page: page_count, per: 50})
      end
      
      if data == 'no token'
        puts "no token"
        limit = page_count
      elsif (data = data["jobs"]) == []
        puts "exit: blank page"
        limit = page_count
      else 
        data.each do |dict|
          if req_state == "completed" 
            
            # createTStamp = Time.parse(dict["created_at"])
            # compTStamp = Time.parse(dict["completed_at"])
            # diffTStamps << (compTStamp - createTStamp).to_i
            # resp_day = dict["completed_at"][8,2]
            stateCode = dict["worker"]["address_state"]
            empStates[stateCode] += 1
            resp_month = dict["completed_at"][5,2]
          else
            resp_month = dict["updated_at"][5,2] 
            if req_state == "in_progress"
              stateCode = dict["worker"]["address_state"]
              empStates[stateCode] += 1
            end
          end
          if resp_month != month
            puts "exit: previous month"
            limit = page_count
            break
          else
            job_id = dict["id"]
            if !id_set.include?(job_id)
              count += 1
              id_set.add(job_id)
            else
              puts "exit: repeated job_id"
              limit = page_count
              break
            end
          end
        end
      end
      page_count += 1
    end
    puts "count: " + count.to_s
    puts "checked " + (page_count - 1).to_s + " pages"
    if req_state == "completed" or req_state == "in_progress" 
      # arraySum = diffTStamps.reduce(0, :+) 
      # avgCompTimes = arraySum / diffTStamps.length
      # puts avgCompTimes / 60 / 12
      # [count, avgCompTimes]
      [count, empStates]
    else
      count
    end
  end
  
end