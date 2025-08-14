# app/services/schwab_api_service.rb

class SchwabApiService
  BASE_URL = 'https://api.schwabapi.com'
  CLIENT_ID = ENV['SCHWAB_API_KEY']
  REDIRECT_URI = 'https://127.0.0.1:3000/api/schwab/callback'
  TYPES = 'TRADE,RECEIVE_AND_DELIVER,DIVIDEND_OR_INTEREST,ACH_RECEIPT,ACH_DISBURSEMENT,CASH_RECEIPT,CASH_DISBURSEMENT,ELECTRONIC_FUND,WIRE_OUT,WIRE_IN,JOURNAL,MEMORANDUM,MARGIN_CALL,MONEY_MARKET,SMA_ADJUSTMENT'

  def self.build_auth_url
    "#{BASE_URL}/v1/oauth/authorize?" +
    "response_type=code" +
    "&client_id=#{CLIENT_ID}" +
    "&redirect_uri=#{REDIRECT_URI}"
  end

  def self.exchange_code_for_token(authorization_code)
    payload = {
      grant_type: 'authorization_code',
      code: authorization_code,
      redirect_uri: REDIRECT_URI
    }

    make_post_request('/v1/oauth/token', payload)
  end

  def self.refresh_access_token(refresh_token)
    payload = {
      grant_type: 'refresh_token',
      refresh_token: refresh_token
    }

    make_post_request('/v1/oauth/token', payload)
  end

  def self.get_account_numbers(access_token)
    make_get_request('/trader/v1/accounts/accountNumbers', access_token)
  end

  def self.get_account_transactions(access_token, account_hash, start_date, end_date)
    base_url = "/trader/v1/accounts/#{account_hash}/transactions"
    params = {
      startDate: start_date.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
      endDate: end_date.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
      types: TYPES
    }

    make_get_request(base_url, access_token, params)
  end

  private

  def self.make_post_request(endpoint, payload)
    uri = URI.parse("#{BASE_URL}#{endpoint}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    headers = TdaApiClient.authorization_header
    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.set_form_data(payload)

    handle_response(http.request(request))
  end

  def self.make_get_request(endpoint, access_token, params = {})
    uri = URI.parse("#{BASE_URL}#{endpoint}?#{URI.encode_www_form(params)}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = "Bearer #{access_token}"

    handle_response(http.request(request))
  end

  def self.handle_response(response)
    case response
    when Net::HTTPSuccess
      { status: :success, body: JSON.parse(response.body) }
    else
      { status: :error, code: response.code, body: response.body }
    end
  end
end
