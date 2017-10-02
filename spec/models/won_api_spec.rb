require 'rails_helper'

RSpec.describe Won_api, type: :model do
    
    context 'when authenticating to acquire a token' do
        
        describe 'and accessing stored api keys' do
            it 'should return the correct publishable key from secrets.yml' do
                expect(Won_api.get_key('pk')).to eq 'pk_live_-uSD2djPd8w9KUZEKhxL'
            end
        
            it 'should return the correct secret key from secrets.yml' do
                expect(Won_api.get_key('sk').length).to eq(28)
                expect(Won_api.get_key('sk')).not_to eq(Won_api.get_key('pk'))
            end
            
            it 'should not return a key if key type is not recognized' do
                expect(Won_api.get_key('ok')).to eq 'ok is not a valid key'
            end
            
        end
        
        describe 'and making a call to api_v2/authenticate' do
            it 'should return a valid token if the credentials are correct' do
                expect(Won_api.issue_token(Won_api.get_key('pk'), Won_api.get_key('sk'))).to be true
            end        
            
            it 'should return invalid token if the credentials are incorrect' do
                expect(Won_api.issue_token(Won_api.get_key('pk'), Won_api.get_key('pk'))).to be false
            end
        end      
        
        describe 'and making a request that requires authentication' do
            it 'should return a valid response if the credentials are correct' do
                expect(Won_api.try_api('https://api.wonolo.com/api_v2/job_requests')).not_to eq('no token')
            end        
            
            it 'should return a valid response if multiple correct parameters are used' do
                expect(Won_api.try_api('https://api.wonolo.com/api_v2/job_requests', {classification: 'w2'})).not_to eq('no token')
            end   
        end
        
    end
    
    context 'when querying the API' do
        
        describe 'and asking for counts of all job states' do
            it 'should return and print total job counts' do
                expect(Won_api.this_Month_Jobs('')).not_to eq('no token')
            end  
        end
        
        describe 'and asking for counts of completed job states' do
            it 'should return and print total completd job counts' do
                expect(Won_api.this_Month_Jobs('completed')).not_to eq('no token')
            end  
        end
        
        describe 'and asking for counts of completed job states' do
            it 'should return and print total completd job counts' do
                expect(Won_api.this_Month_Jobs('no_show')).not_to eq('no token')
            end  
        end
    
    
    end
end 
    
    