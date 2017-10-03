require 'httparty'
require 'json'
require 'time'
require 'set'

class Won_api 
  
  @token = ''
  WON_ADDR = "https://api.wonolo.com/api_v2/"
  JOB_ADDR = "jobs"
  JOB_REQS_ADDR = "job_requests"
  AUTH_ADDR = "authenticate"
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
    response = HTTParty.post(WON_ADDR+AUTH_ADDR, body: {api_key: p_key, secret_key: s_key})
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
  
  
  def self.this_Month_Jobs(req_state, job_requests=false, limit=20, add_params=false)
    job_requests ? query_add = JOB_REQS_ADDR : query_add = JOB_ADDR
    year = Time.now.year.to_s
    month = Time.now.month.to_s
    if month.length == 1 then month = '0' + month end
    count = 0
    page_count = 1
    returnArray = [] 
    # empStates = Hash.new 0
    # jobCategory = Hash.new 0
    id_set = Set.new
    
    puts "////////////// checking state: " + req_state + " //////////////"
    while page_count <= limit
      puts "********** page:" + page_count.to_s + ", current count: " + count.to_s
      if req_state == ''
        data = try_api(WON_ADDR+query_add, {page: page_count, per: 50})
      else
        data = try_api(WON_ADDR+query_add, {state: req_state, page: page_count, per: 50})
      end
      if data == 'no token'
        puts "no token"
        limit = page_count
      elsif (data = data[query_add]) == []
        puts "exit: blank page"
        limit = page_count
      else 
        data.each do |dict|
          if job_requests or req_state != "completed" 
            date = dict["updated_at"]
          else
            date = dict["completed_at"]
          end
          resp_year = date[0,4] 
          resp_month = date[5,2]
          
          if resp_month != month or resp_year != year
            puts "exit: previous month"
            limit = page_count
            break
          else
            # if job_requests
            #   category = dict["category"]
              
            #   jobCategory[category] +=1 
            # else
            #   stateCode = dict["worker"]["address_state"]
            #   empStates[stateCode] += 1
            # end
            
            job_id = dict["id"]
            if id_set.include?(job_id)
              puts "exit: repeated job_id"
              limit = page_count
              break
            else
              
              jobHash = {} 
              jobHash[:job_id] = dict["id"] 
              jobHash[:job_state] = dict["state"] 
              jobHash[:updated_at] = dict["updated_at"] 
              if job_requests
                jobHash[:category] = dict["category"] 
              else
                jobHash[:created_at] = dict["created_at"] 
                jobHash[:completed_at] = dict["completed_at"] 
                jobHash[:worker_first] = dict["worker_first"] 
                jobHash[:worker_second] = dict["worker_second"] 
                jobHash[:worker_avatar] = dict["worker_avatar"] 
                jobHash[:worker_state] = dict["worker_state"] 
                jobHash[:employer_name] = dict["employer_name"] 
              end
              
              returnArray << jobHash  
              # count += 1
              # id_set.add(job_id)
            end
          
            
          end
        end
      end
      page_count += 1
    end
    puts "count: " + count.to_s
    puts "checked " + (page_count - 1).to_s + " pages"
    # if job_requests
    #   jobCategory
    # else
    #   [count, empStates]
    # end
    returnArray
  end
  
  
  def self.getNextCompletes(page_num, page_size)
    data = try_api(WON_ADDR+JOB_ADDR, {state: "completed", page: page_num, per: page_size})
    if data == 'no token'
      puts "no token"
      limit = page_count
    elsif (data = data[JOB_ADDR]) == []
      puts "exit: blank page"
      limit = page_count
    else 
      returnArray = []
      data.each do |dict|
        workerDict = dict["worker"]
        employerDict = dict["employer"]
        
        completeData = [dict["completed_at"]]
        completeData << workerDict["first_name"]
        completeData << workerDict["last_name"]
        completeData << workerDict["state"]
        completeData << workerDict["avatar_url"]
        completeData << employerDict["business_name"]
        
        returnArray << completeData
      end
    end 
    returnArray
  end
  
end