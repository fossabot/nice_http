require 'nice_http'

RSpec.describe NiceHttp, '#put' do

    before do
        @http = NiceHttp.new('https://www.reqres.in')
    end
    
    it 'accepts hash including keys :data and :path' do
        resp = @http.put( {
            path: "/api/users/2",
            data: { name: "morpheus", job: "HR leader" } 
        } )
        expect(resp.code).to eq 200
        expect(resp.data.json(:job)).to eq "HR leader"
    end

    it 'accepts parameters as array of path, data, headers' do
        resp = @http.put( "/api/users/2", "{ 'name': 'morpheus', 'job': 'leader2' }", {} )
        expect(resp.code).to eq 200
    end

    it 'returns error in case no path' do
        resp = @http.put({data: { name: "morpheus", job: "leader" }})
        expect(resp.class).to eq Hash
        expect(resp.fatal_error).to match /no[\w\s]+path/i
        expect(resp.code).to eq nil
        expect(resp.message).to eq nil
        expect(resp.data).to eq nil
    end

    it 'accepts data_examples array in case no data supplied' do
        resp = @http.put( {
            path: "/api/users/2",
            data_examples: [{ name: "doopy", job: "loope" }] 
        } )
        expect(resp.code).to eq 200
        expect(resp.data.json(:name)).to eq 'doopy'
    end
    
    it 'returns the mock response if specified' do
        @http.use_mocks = true
        request = {
            path: "/api/users/2",
            data: { name: "morpheus", job: "leader" },
            mock_response: {
                code: 100,
                message: "mock",
            }
        } 
        
        resp = @http.put(request)
        expect(resp.class).to eq Hash
        expect(resp.code).to eq 100
        expect(resp.message).to eq 'mock'    
    end
    
    it 'changes :data when supplied :values_for' do
        request = {
            path: "/api/users",
            data: { name: "morpheus", job: "leader" } 
        }

        request.values_for = {name: "peter"}
        resp = @http.put(request)
        expect(resp.code).to eq 200
        expect(resp.data.json(:name)).to eq 'peter'
    end

    #todo: add tests for redirection, headers, encoding and cookies

end
