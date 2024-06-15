class AppleToken
  APPLE_PUBLIC_KEYS_URL = 'https://appleid.apple.com/auth/keys'.freeze
  attr_reader :apple_public_keys

  def initialize
    @apple_public_keys = fetch_apple_public_keys
  end

  def decode_identity_token(identity_token, user_identity)
    header = decode_header(identity_token)
    key = find_matching_key(header['kid'])

    return nil unless key

    jwk = JWT::JWK.import(key)
    decoded_token = decode_jwt(identity_token, jwk.public_key, header['alg'])

    if valid_token?(decoded_token, user_identity)
      decoded_token
    else
      nil
    end
  end

  private

  def fetch_apple_public_keys
    response = Faraday.get(APPLE_PUBLIC_KEYS_URL)
    JSON.parse(response.body)['keys']
  end

  def decode_header(identity_token)
    JWT.decode(identity_token, nil, false).last
  rescue JWT::DecodeError => e
    puts "Error decoding token header: #{e.message}"
    nil
  end

  def find_matching_key(kid)
    @apple_public_keys.find { |key| key['kid'] == kid }
  end

  def decode_jwt(identity_token, public_key, algorithm)
    JWT.decode(identity_token, public_key, true, { algorithm: algorithm }).first
  rescue JWT::DecodeError => e
    puts "Error decoding JWT: #{e.message}"
    nil
  end

  def valid_token?(token_data, user_identity)
    token_data.key?('sub') && token_data.key?('email') && token_data['sub'] == user_identity
  end
end
